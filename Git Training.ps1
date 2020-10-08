################################################################
# BD Jedi Order Git Training
################################################################

#https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/about-authentication-to-github
#https://docs.github.com/en/free-pro-team@latest/github/getting-started-with-github/set-up-git#next-steps-authenticating-with-github-from-git
#https://docs.github.com/en/free-pro-team@latest/github/using-git/which-remote-url-should-i-use#cloning-with-https-urls
#https://docs.github.com/en/free-pro-team@latest/github/using-git/caching-your-github-credentials-in-git

################################################################
# Configure Information that may differ by each person's machine
################################################################

Clear-Host

# Get current Git
git version
git update-git-for-windows

#region Configuration

$TrainingRootFolder = "C:\Training\Git"

################################################################
# Clone the Training materials.  Only need to do this once
################################################################

$ChristopherGitHub = "https://github.com/chrhodes"
git clone $ChristopherGitHub/GitTraining.git
git clone $ChristopherGitHub/GitTrainingContent.git

$GitTraining = "C:\Training\Git\GitTraining"
$GitTrainingContent = "C:\Training\Git\GitTrainingContent"

#region GitRepos

#$vncRepo = "C:\vnc\git\vnc"

# Red Team

$VikramjeetGitHub = "https://github.com/vikramjeetlotey"
$KrishanGitHub = "https://github.com/krishanDanyal"

# Green Team

$GyanGitHub = "https://github.com/vermagyan09"
$PushpGitHub = "https://github.com/pushpgaurav28"

# Blue Team

$AjayGitHub = "https://github.com/stridersol"
$RohiniGitHub = "https://github.com/RohiniSharma11"

# Purple Team

$ChristopherGitHub = "https://github.com/chrhodes"

#endregion

#endregion

################################################################
# Need to load supporting functions before starting to work.
#
# These help display info in the Git Repo and the Working Area
# Mostly used to help you learn the internals of .Git which you
# can the promptly forget
#
#   displayGitRepo
#
#     displayObjectsFolder
#     displayObjects
#     displayHEAD
#     displayBranchs
#     displayBlobInfo( [string] $sha1 )
#     getSHA1s
#
#   displayWorkingArea
#
# These run several things that help you see whats going on
# You will likely just use git status once you understand
#
# whatsUpGit
# whatsUpGitLong
#
# This separates output to make it easier to see
#
#   delimitmsg
#
################################################################

cd $TrainingRootFolder
. '.\GitTraining\Git Training Functions.ps1'

################################################################
# 
# Git 000
#
# Covers these commands and concepts
#
#   git version
#   git help
#   git init
#   git status
#   git log
#   git branch
#   git count-objects
#
################################################################

#region Git 000

cd $TrainingRootFolder
Clear-Host

# Check what version you are running
# Download new versions from here
# https://git-scm.com/downloads

git version

# Create new folder (cleaning up any existing)

Remove-Item -path EmptyGitRepo -Force -Recurse
New-Item -Path EmptyGitRepo -ItemType Directory
cd .\EmptyGitRepo

#show createRepo - We will use that going forward

#region Help and some basics

git help
git help -g
git help -a

#Config Intro - We will cover this in detail later in Git102

git config -l  # git config -list

git config -l --show-origin --show-scope

#git help <command>
#git help <command> -v

#NB - Be really careful as git help command launches browser and locks folder 

#endregion

#region Dip Our Toe in the Water

# create a new empty repository

git init

# Check what git thinks is happening

git status

# Show history of what has happened

git log

# In time you will learn more log options, for now just know they are there

git help log

# Check out what is happening with branches
# since we haven't added and committed anything yet, list is empty

# Local Repository

git branch

# Local and remote repository branches

git branch -a

displayBranches

# Oh, yeah, one more thing
# If you see this

git Log

# Do this (lowercase)

git log

# See how many and how big

git count-objects

# Introduce posh-git Prompt

https://github.com/dahlbyk/posh-git/blob/master/README.md#git-status-summary-information
PowerShellGet\Install-Module posh-git -Scope CurrentUser -AllowPrerelease -Force

# Might want to use ZLocation
# https://github.com/vors/ZLocation

Install-Module ZLocation -Scope CurrentUser

#endregion

#region Optional Extra Credit - But let's do it anyway

<#********************************************************************
This is an Optional Extra Credit Section that should only be done
to show how to look at the objects that get created and learn about SHA1

We will zap the repository and start again at the end of this section.

# Covers these commands and concepts
#
#   git-hash-object
#   git cat-file

Also introducing use of functions, see Git Training Functions.ps1

    displayObjectsFolder
    getSHA1s
    displayObjects

**********************************************************************#>

displayObjectsFolder
getSHA1s
displayObjects

# Generate a SHA1 usign a "Plumbing Command"
# This just returns a SHA1, it doesn't do anything with it
# Note the SHA1 is a long (globaly unique number)
#
# See it in two parts
#     First two characters
#     Remaining characters
#
# Git can work with full SHA1 or just first four characters

echo "Hello JediOrder" | git hash-object --stdin

# Add the blob to the index

echo "Hello JediOrder!" | git hash-object -w --stdin

# Go look at what just happened

whatsUpGitLong

git commit -m "Commit Blob"

# Go look at what just happened

whatsUpGitLong

<#********************************************************************
End Optional Extra Credit Section
**********************************************************************#>

#endregion

# Ok, lets pretend we didn't do any of that
# Start Clean

#endregion

################################################################
# 
# Git 100
#
# Covers these commands and concepts
#
#   git version
#   git help
#   git init
#   git status
#   git log
#   git branch
#   git count-objects
#
################################################################

Clear-Host
cd $TrainingRootFolder

# Create new folder (cleaning up any existing)

createRepo NewGitRepo

# Let's see what is in a Git Repo (.git folder)

displayGitRepo

# Introduce whatsUpGitLong so we don't have to look in .git folder

whatsUpGitLong

# Copy in contents of starting files from GitTrainingContent

cd $GitTrainingContent

git checkout Start

displayWorkingArea

copy-item -Path .\recipies.txt -Destination ..\NewGitRepo
copy-item -Path .\Breakfast -Destination ..\NewGitRepo -Recurse
copy-item -Path .\Dinner -Destination ..\NewGitRepo -Recurse

cd $TrainingRootFolder\NewGitRepo

# What is in the Working Area?

displayWorkingArea

# What does Git think is happening?
# whatsUpGit is a little less verbose

whatsUpGit

# Note the difference between how git status behaves with untracked files

#git status
#git status --untracked-files

git add .

whatsUpGitLong

# What got created?  Did the number of objects surprise you?

# We could do a commit right now, 
# but let's stage (add to index area) a few more files.

# Lets go and update the recipies.txt file and add eggs.txt and tacos.txt

cd $GitTrainingContent
displayWorkingArea

git checkout FirstUpdate
displayWorkingArea

copy-item -Path .\recipies.txt -Destination ..\NewGitRepo -Force
copy-item -Path .\Breakfast -Destination ..\NewGitRepo -Recurse -Force
copy-item -Path .\Dinner -Destination ..\NewGitRepo -Recurse -Force

cd $TrainingRootFolder\NewGitRepo

# What does git think happened

whatsUpGit

git diff

# What do we see in .git and .git\objects
# Pay attention to the new files in the objest folder.  Any surprises?

whatsUpGitLong

git add .

whatsUpGitLong

# All right, let's commit this

git commit -m "First Commit" 

# Now what does .git know

whatsUpGitLong

whatsUpGit

# Ok, a lot just happened.  Let's see if we can understand it
# Using our knowledge of object types

Clear-Hos
displayObjects commit
displayObjects tree
displayObjects blob

# Add Sandwich.txt to Lunch folder

cd $GitTrainingContent
displayWorkingArea

git checkout SecondUpdate
displayWorkingArea

copy-item -Path .\Lunch -Destination ..\NewGitRepo -Recurse -Force
cd $TrainingRootFolder\NewGitRepo

git status

git add .

git status

git commit -m "Add Sandwich.txt"

# Update recipies.txt to include the Sandwich

cd $GitTrainingContent
displayWorkingArea

git checkout SecondUpdate
displayWorkingArea

copy-item -Path .\recipies.txt -Destination ..\NewGitRepo -Force

cd $TrainingRootFolder\NewGitRepo

git status

git add .

git status

git commit -m "Update recipies.txt"

displayObjects commit
displayObjects tree
displayObjects blob

# You can use git log to see a commit

git log da95

# One final type of Object - Tags

# Create new empty repo
# commit a file
# add an annotated tag

git tag -a mytag -m "Tag Message"
git tag
git cat-file -p mytag
git cat-file -t mytag
# can also pass sha1

# just a tag (no blob to hold content)

git tag -a anothertag

# Let's look back at all we did


# Show history of what has happened

git log
git log --oneline
git log --oneline --graph
git log --oneline --graph --decorate
git log --oneline --graph --decorate --all
git log --stat
git log --patch

# And just for fun, let's go look at how 
# the GitTrainingContent folder progressed

cd $GitTrainingContent

git log
git log --oneline
git log --oneline --graph
git log --oneline --graph --decorate
git log --oneline --graph --decorate --all
git log --stat
git log --patch

# All right.  You made it.  Go forth and Git!

#endregion

################################################################
# 
# Git102
#
# Covers these commands and concepts
#
#    git config
#
#    git branch
#    git merge
#
################################################################

#region Git 102

<#**************************************************************
    Configuring Git

    git config
    git config --list
   
**************************************************************#>

# Check if anything exists in environment

get-childitem env:*user*

get-childitem env:*config*
get-childitem env:*git*

git config
git config -l  # git config -list

git config -l --show-origin
git config -l --show-scope
git config -l --show-origin --show-scope

git config --system --edit
git config --global --edit

git config --local --edit
git config --worktree

<#**************************************************************
    Quick preview of cloning remote repos
**************************************************************#>

#region Cloning

# Clone a remote repository

# NB. If this doesn't work, check that you are using the VPN

cd $TrainingRootFolder\JediRepos

# Red Team

git clone $VikramjeetGitHub/RedTeam.git RedTeam_Vikramjeet
git clone $KrishanGitHub/RedTeam.git RedTeam_Krishan

# Green Team

git clone $GyanGitHub/GreenTeam.git GreenTeam_Gyan
git clone $PushpGitHub/GreenTeam.git GreenTeam_Pushp

# Blue Team

git clone $RohiniGitHub/BlueTeam.git BlueTeam_Rohini
git clone $AjayGitHub/BlueTeam.git BlueTeam_Ajay

# Purple Team

git clone $ChristopherGitHub/PurpleTeam.git PurpleTeam_Christopher

cd $TrainingRootFolder

git clone $ChristopherGitHub/GitTraining.git
git clone $ChristopherGitHub/GitTrainingContent.git

# Push to a (empty) Remote Repository

#git remote add origin https://github.com/chrhodes/JediOrder.git

#git remote -v

# Get the GitTraining Repo
# You will start using this to create a mess

#git clone $ChristopheGitHub/JediOrder.git

#endregion

#region Branch Hacking

<#*********************************************************************************
    Hacking Around to create Branches in JediOrder
    To start each team out with something to use.
*********************************************************************************#>

# Clean Up in case we have done this before

git branch -D RedTeam
git branch -D GreenTeam
git branch -D BlueTeam
git branch -D PurpleTeam

git push origin --delete RedTeam
git push origin --delete GreenTeam
git push origin --delete BlueTeam
git push origin --delete PurpleTeam

# Remember case matters

git Branch
git branch

# Create some branches

git branch RedTeam

git branch GreenTeam

git branch BlueTeam

git branch PurpleTeam

# Checkout the Purple Team
# Sets Index and Working Area to LocalRepository PurpleTeam

git checkout PurpleTeam

n++ recipies.txt
n++ README.txt

mkdir Breakfast
n++ README.txt
mkdir Lunch
# Copy README.txt from Breakfast
mkdir Dinner
# Copy README.txt from Breakfast

git commit -a -m "Staring Files and Folders"

# Push changes to Remote Origin PurpleTeam Branch

git push

git remote
git remote -v

# Checkout each team and
# cherry-pick the changes from the PurpleTeam Commit

git checkout RedTeam

git cherry-pick f0f6

git checkout BlueTeam

git cherry-pick f0f6

git checkout GreenTeam

git cherry-pick f0f6

# Show TortiseGit UI
# Show SourceTree UI

# Makes some changes in files

#endregion


<#*********************************************************************************
    Learn About Merging
*********************************************************************************#>

#####################
# Fast Forward Merge
#####################

createRepo Git102Repo

New-Item -Path . -Name recipies.txt -ItemType "file" -Value "Breakfast
Dinner"
get-content .\recipies.txt
git add .
git commit -m "My Recipies"
git branch Chef
git checkout Chef
New-Item -Path . -Name recipies.txt -ItemType "file" -Value "Breakfast
Lunch
Afternoon Tea
Dinner
Bedtime Snack" -Force
get-content .\recipies.txt
git add .\recipies.txt
git commit -m "Master Chef Recipies"

git checkout master
get-content .\recipies.txt

# This is considered a fast forward merge

git merge Chef

#####################
# Conflict Merge
#####################

createRepo Git102ARepo

New-Item -Path . -Name recipies.txt -ItemType "file" -Force
get-content .\recipies.txt

git add .
git commit -m "No Recipies"

# THIS IS KEY.  When does the branch get created.

git branch Chef

New-Item -Path . -Name recipies.txt -ItemType "file" -Value "Breakfast
Dinner" -Force
get-content .\recipies.txt

git add .
git commit -m "My Recipies"

git checkout Chef

get-content .\recipies.txt

New-Item -Path . -Name recipies.txt -ItemType "file" -Value "Breakfast
Lunch
Afternoon Tea
Dinner
Bedtime Snack" -Force
get-content .\recipies.txt

git add .\recipies.txt
git commit -m "Master Chef Recipies"

git checkout master
get-content .\recipies.txt

# Cannot do fast forward merge - resolve then commit

git merge Chef
get-content .\recipies.txt
n++ .\recipies.txt

git add .\recipies.txt
git commit -m "Our Recipies"

git checkout Chef
get-content .\recipies.txt

#endregion

################################################################
#
# Git103
#
# Covers these commands and concepts
#
#
################################################################

#region Git 103


createRepo GitCommands

git status

New-Item -Path . -Name recipies.txt -ItemType "file"

git status

git diff
git diff --cached

git add .

# Notice that a blob got created
displayobjects

git status

git diff
git diff --cached

git commit -m "Empty File"

git status

git diff
git diff --cached

Set-Content -Path .\recipies.txt -Value "Breakfast"

git status

git diff
git diff --cached

git add .

git status

git diff
git diff --cached

git commit -m "Update recipies.txt"

git status

git diff
git diff --cached

git log

displayObjects commit

#endregion


