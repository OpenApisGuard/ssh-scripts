#!/bin/bash
if [ $# -ne 4 ]
  then
    echo "Diff file-to-diff from from-branch to to-branch then apply diff to new-pr-branch"
    echo "Usage: git-diff-update-create-new-branch.sh [from-branch] [to-branch] [new-pr-branch] [file-to-diff]"
    echo "Example: git-diff-update-create-new-branch.sh develop master pr/master version"
    exit
fi

echo "--- Make sure from-branch is avaliable --- : git checkout" $1
git checkout $1
git pull

files=$(find . -name $4)
fileLine=""
s=""

for i in $files;
do 
	if [ $s=="start" ];
	then
		fileLine+=" "
	fi
	fileLine+=$i
	s="start"
done

echo "git checkout" $2
git checkout $2
git pull

echo "--- Create new PR branch --- : git checkout -b " $3
git checkout -b $3

echo "--- Update versions from from-branch --- : git checkout --force " $1 $fileLine
git checkout -f $1 $fileLine
git status

git branch

echo "Verify updates: git diff origin/" $2
echo "Revert change to a file: git checkout origin/" $2 "-- <file>"
echo "Add files: git add " $fileLine
echo "Commit updates: git commit -m \"Updated $4\""
#git commit -m "Updated image versions"
