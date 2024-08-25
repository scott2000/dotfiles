#!/usr/bin/env fish

if test "$SHLVL" -gt 1
  exit
end

# Remind to update flake after 30 days
set reminder_time (math '60 * 60 * 24 * 30')

set flake_lock_revset 'latest(heads(file(root:flake.lock)))' 
set timestamp_template  'committer.timestamp().utc().format("%s")'
set human_readable_template 'committer.timestamp().ago()'

set last_modified_timestamp (
  jj log -R ~/dotfiles --no-graph -r $flake_lock_revset -T $timestamp_template
)

set elapsed (math (date +%s) - $last_modified_timestamp)

if test $elapsed -ge $reminder_time
  set human_readable_time (
    jj log -R ~/dotfiles --no-graph -r $flake_lock_revset -T $human_readable_template
  )
  echo "Reminder: Last `nix flake update` for dotfiles was $human_readable_time."
end

