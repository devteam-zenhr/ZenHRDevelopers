#!/bin/bash

set -e # Exit on errors

if [ -n "$TMUX" ]; then
  export NESTED_TMUX=1
  export TMUX=''
fi

if [ ! $ZENHR_DEVELOPERS_DIR ]; then export ZENHR_DEVELOPERS_DIR=$HOME/workspace/ZenHRDevelopers; fi

cd $ZENHR_DEVELOPERS_DIR

tmux new-session  -d -s ZenHRDevelopers
tmux set-environment -t ZenHRDevelopers -g ZENHR_DEVELOPERS_DIR $ZENHR_DEVELOPERS_DIR

tmux new-window      -t ZenHRDevelopers  -n 'Web'
tmux send-key        -t ZenHRDevelopers  'cd ZENHR_DEVELOPERS_DIR' Enter 'bundle exec jekyll serve' Enter

tmux new-window      -t ZenHRDevelopers -n 'Vim'
tmux send-key        -t ZenHRDevelopers 'cd $ZENHR_DEVELOPERS_DIR' Enter 'vim .'                    Enter

if [ -z "$NESTED_TMUX" ]; then
  tmux -2 attach-session -t ZenHRDevelopers
else
  tmux -2 switch-client -t ZenHRDevelopers
fi
