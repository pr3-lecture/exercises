#!/bin/sh

# Function to clone a repository
function clone {

    REPO_NAME=$1

    if [ ! -d "$REPO_NAME" ]; then
      git clone git@github.com:pr3-lecture/$REPO_NAME.git
    fi
}

# Function to update a repository with actual changes
function update {
    REPO_NAME=$1

    cd $REPO_NAME
    git pull origin master
    cd ..

#    rsync --exclude=.git --delete --update -raz __template/koans/ $REPO_NAME/koans
    rsync --exclude=.git --delete --update -raz __template/koans/ $REPO_NAME/koans

    cp __template/readme.md $REPO_NAME
    cp __template/.gitignore $REPO_NAME

    cd $REPO_NAME

    git add .
    git commit -m "I Robot"
    git push origin master
    cd ..
}

# Synchronize the template directory with this one
pushd ../../PR3_Repos
rsync --exclude=*-solution -a --delete ../PR3/11_Labs/ __template

# Loop repos and push changes
for REPO in {53..53}
do
    if [ "$REPO" -lt "10" ]
	then
    	NAME=repo-0$REPO
    else
    	NAME=repo-$REPO
    fi

    clone $NAME
    update $NAME
done

# Clean repo with all exercises
rsync --exclude=.git --delete --update -raz __template/ exercises
cd exercises
git add .
git commit -m "Updated exercises"
git push origin master
cd ..

popd
