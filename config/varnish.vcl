# Selects a backend at random
director cl1 random {
  { .backend = {
    .host = "127.0.0.1";
    .port = "5200"; }
    .weight = 1; }
  { .backend = {
    .host = "127.0.0.1";
    .port = "5201"; }
    .weight = 1; }
  { .backend = {
    .host = "127.0.0.1";
    .port = "5202"; }
    .weight = 1; }
  { .backend = {
    .host = "127.0.0.1";
    .port = "5203"; }
    .weight = 1; }
}

sub vcl_recv {
  # Determine the backend
  set req.backend = cl1;

  # Don't cache POST, PUT, or DELETE requests
  if (req.request == "POST" || req.request == "PUT" || req.request == "DELETE") {
    return(pass);
  }

  # Clearing cache via BAN
  if (req.request == "PURGE") {
    ban_url(req.url);
    error 200 "Banned URLS matching: " + req.url;
    # ban("req.http.host == " +req.http.host+" && req.url ~ "+req.url);
    # error 200 "Ban added to " + req.url;
  }

  # Varnish will keep two variants of the page requested due to the different
  # Accept-Encoding headers. Normalizing the accept-encoding header will
  # ensure that you have as few variants as possible. The following VCL code
  # will normalize the Accept-Encoding headers:
  # https://www.varnish-cache.org/docs/trunk/tutorial/vary.html#tutorial-vary
  if (req.http.Accept-Encoding) {
    if (req.url ~ "\.(jpg|png|gif|gz|tgz|bz2|tbz|mp3|ogg)$") {
      # No point in compressing these
      unset req.http.Cookie;
      remove req.http.Accept-Encoding;
    } elsif (req.http.Accept-Encoding ~ "gzip") {
      set req.http.Accept-Encoding = "gzip";
    } elsif (req.http.Accept-Encoding ~ "deflate") {
      set req.http.Accept-Encoding = "deflate";
    } else {
      # unknown algorithm
      unset req.http.Accept-Encoding;
    }
  }

  # Assumes that object is cachable
  return(lookup);
}

sub vcl_fetch {
  # ETag removal, if this is present ESI will not work for cached blocks
  remove beresp.http.ETag;

  # Remove the Vary header, we don't treat clients differently
  remove beresp.http.Vary;

  # We want ESI
  set beresp.do_esi = true;

  # If header specifies "max-age", remove any cookie and deliver into the cache.
  # The idea here is to trust the backend. If the backend set a max-age in
  # the Cache-Control header, then the response should be cached even if there
  # is a Set-Cookie header. The cleaner way to handle this is the not set a
  # Set-Cookie header in the backend, but unfortunately Rails always sets one.
  if(beresp.http.Cache-Control ~ "max-age") {
    unset beresp.http.Set-Cookie;
    return(deliver);
  }

  # We should also deliver all static assets into the cache regardless of the
  # caching strategy specified.
  if(req.url ~ "^/assets/") {
    unset beresp.http.Set-Cookie;
    set beresp.ttl = 31536000s; # approx 1 year
    set beresp.http.Cache-Control = "public, max-age=31536000";
    return(deliver);
  }

  # Do not deliver into cache otherwise.
  return(hit_for_pass);
}

sub vcl_deliver {
  if (obj.hits > 0) {
    set resp.http.X-Varnish-Cache = "HIT (" +obj.hits+ ")";
  } else {
    set resp.http.X-Varnish-Cache = "MISS";
  }
  return(deliver);
}

#https://www.varnish-cache.org/trac/wiki/VCLExampleCachingLoggedInUsers
sub vcl_hash {
  # these 2 entries are the default ones used for vcl. Below we add our own.
  hash_data(req.url);
  hash_data(req.http.host);

  # regsub replaces only the bit in your match criteria with whatever you
  # ask it too. In this case, we need to remove *EVERYTHING* else from the
  # cookie, except the UUID, hence the full string match
  # This is using the UUID, which will always stay the same. If you wish
  # to cache based on the session, you could use "myapp_session" instead.
  # The regex is PCRE, so it works only in trunk. If you wish to use it
  # with Varnish 2.0, remove the '?' non-greedy operator and be aware it
  # changes the behavior of the regex.
  if( req.http.Cookie ~ "_emil_kampp_session" && req.http.Cookie ~ "_logged_in" ) {
    set req.http.X-Varnish-Hashed-On = regsub( req.http.Cookie, "^.*?_emil_kampp_session=([^;]*);*.*$", "\1" );
  }

  # if the esi request is UUID specific, add the UUID to the hashing
  # The only requirement on the application is now that UUID specific
  # content mentions the string UUID in it.
  if( req.url ~ "/esi/uuid/" && req.http.X-Varnish-Hashed-On ) {
    hash_data(req.http.X-Varnish-Hashed-On);
  }

  # if the esi request is LOGIN specific, add a string to the hashing
  # The only requirement on the application is now that LOGIN specific
  # content mentions the string LOGIN in it.
  if( req.url ~ "/esi/login/" && req.http.X-Varnish-Hashed-On ) {
    hash_data("logged in");
  }

  return(hash);
}

sub vcl_error {
    set obj.http.Content-Type = "text/html; charset=utf-8";

    synthetic {"
        <?xml version="1.0" encoding="utf-8"?>
        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
            "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
        <html>
            <head>
                <title>Emil Kampp</title>
            </head>
            <body>
                <h1>Maintenance in progress..</h1>
                <p>The site is undergoing some maintenance, we should be back online momentarily.</p>
            </body>
        </html>
    "};
    return(deliver);
}
