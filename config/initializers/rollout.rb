$redis   = Redis.new
$rollout = Rollout.new($redis)

$rollout.define_group(:developer) do |user|
  user.admin?
end
