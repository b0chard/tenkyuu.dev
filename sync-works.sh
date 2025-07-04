#!/bin/bash

declare -A submodules=(
  ['roman-numeral-converter']='git@github.com:b0chard/roman-numeral-converter.git'
  ['palindrome-checker']='git@github.com:b0chard/palindrome-checker.git'
  ['temperature-converter']='git@github.com:b0chard/temperature-converter.git'
  ['drum-ka-dum']='git@github.com:b0chard/drum-ka-dum.git'
  ['tick-clock']='git@github.com:b0chard/tick-clock.git'
  ['simple-cash-register']='git@github.com:b0chard/simple-cash-register.git'
  ['circle']='git@github.com:b0chard/circle.git'
  ['basic-calc']='git@github.com:b0chard/basic-calc.git'
  ['signup-login-system']='git@github.com:b0chard/signup-login-system.git'
  ['number-guessing-game-in-c']='git@github.com:b0chard/number-guessing-game-in-c.git'
  ['rock-paper-scissors-in-c']='git@github.com:b0chard/rock-paper-scissors-in-c.git'
  ['atm-program-in-c']='git@github.com:b0chard/atm-program-in-c.git'
)

tmpBase='works-tmp'
worksBase='works'

mkdir -p "$tmpBase" "$worksBase"

echo "Checking and adding missing submodules in $tmpBase..."
for submodule in "${!submodules[@]}"; do
  tmpPath="$tmpBase/$submodule"
  destPath="$worksBase/$submodule"

  if [ ! -d "$tmpPath" ]; then
    echo "Adding submodule $submodule to $tmpBase..."
    git submodule add -f "${submodules[$submodule]}" "$tmpPath"
    echo "Submodule $submodule added successfully to $tmpPath."
  else
    echo "Submodule $submodule already exists in $tmpBase."
  fi
done

echo "Uploading all submodules in $tmpBase to latest remote commits..."
git submodule update --remote --merge
echo "Submodules has been successfully updated to latest remote commits."

echo "Synchronizing submodules content from $tmpBase to $worksBase..."
for submodule in "${!submodules[@]}"; do
  src="$tmpBase/$submodule"
  dest="$worksBase/$submodule"

  if [ -d "$src" ]; then
    mkdir -p "$dest"
    rsync -av --delete --exclude='.git' "$src/" "$dest/"
    echo "Synchronized submodule $submodule successfully."
  else
    echo "Warning: $src does not exist, skipping synchronization!"
  fi
done

echo "Staging changes in $worksBase..."
git add "$worksBase/"

echo "Committing changes..."
git commit -m "Sync latest updates from submodules to works/ directory." || echo "Nothing to commit."

echo "done."