# BD Jedi Order Git Training

#region Configuration

# Configure Information that may differ by each person's machine

$TrainingRootFolder = "C:\Training\Git"

# Red Team

$VikramjeetGitHub = "https://github.com/vikramjeetlotey"
$KrishanGitHub = "https://github.com/krishanDanyal"

# Green Team

$GyanGitHub = "https://github.com/vermagyan09"
$PushpGitHub = "https://github.com/pushpgaurav28"

# Blue Team

$AjayGitHub = "https://github.com/stridersol"
$RohiniGitHub = "https://github.com/???"

# Purple Team

$ChristopheGitHub = "https://github.com/chrhodes/PurpleTeam.git"

#endregion

#region Help

git help
git help -g
git help -a
#git help <command>
#git help <command> -v

#endregion

#region functions

# git cat-file
# Provides content or type and size information for repository objects

git help cat-file
git --help cat-file

# Displays information on objects whose SHA1 values are passed in
# Can limit by $blobType if passed, e.g. commit|tree|blob

function displayObjects ($blobType = "")
{
    $sha1Folders = (getSHA1s)

   # $sha1Folders

    if($blobType -eq "")
    {
        "Showing all objects"

        foreach ($sha1 in $sha1Folders)
        {
            "sha1 $sha1 is a >>> " + (git cat-file $sha1 -t) + " <<<"
            "sha1 $sha1 contains: >>>" + (git cat-file $sha1 -p) + "<<<"
            ""
        }
    }
    else
    {
        "Showing only = $blobType"

        foreach ($sha1 in $sha1Folders)
        {
            $objectType = (git cat-file $sha1 -t)

            if($blobType -eq $objectType)
            {          
                "sha1 $sha1 is a >>> " + (git cat-file $sha1 -t) + " <<<"
                "sha1 $sha1 contains: >>>" + (git cat-file $sha1 -p) + "<<<"
                ""
            }
        }
    }
}

# Gets SHA1 values from Objects folder.

function getSHA1s()
{
    $objects = ".\.git\objects"

    $objectFolders = get-childitem -Path $objects -Filter "??" | % { $_.Name }

    $listOfSHA1s = @()

    foreach ($fld in $objectFolders)
    {
        # There can be more than one file in the top level folder

        foreach($f in get-childitem -Path $objects\$fld)
        {
            $firstTwo = $f.Name.Substring(0,2)
            $listOfSHA1s = $listOfSHA1s + ($fld + $firstTwo)   
        }
    }

    # Return array.  See the ","

    return ,$listOfSHA1s
}

function displayObjectsFolder()
{
    $objects = ".\.git\objects"

    $objectFolders = get-childitem -Path $objects

    $objectFolders

    foreach ($fld in $objectFolders)
    {
        get-childitem -Path $objects\$fld
    }
}

function displayBranches()
{
    $refs = ".\.git\refs"

    $refsFolders = get-childitem -Path $refs

    "refs\ contains"

    $refsFolders

    foreach ($fld in $refsFolders)
    {
        get-childitem -Path $refs\$fld
    }

    "HEAD contains"
    get-content .\.git\HEAD
}

function whatsUpGitLong()
{
    delimitmsg "git status"

    git status

    delimitmsg "git branch -a"

    git branch -a

    delimitmsg "displayObjectsFolder"

    displayObjectsFolder

    delimitmsg "getSHA1s"

    getSHA1s

    delimitmsg "displayObjects(getSHA1s())"

    displayObjects
}

function whatsUpGit($blobType = "")
{
    delimitmsg "git status"

    git status

    delimitmsg "git branch -a"

    git branch -a

 #   delimitmsg "displayObjectsFolder"

 #   displayObjectsFolder

 #   delimitmsg "getSHA1s"

  #  getSHA1s

    delimitmsg "displayObjects $blobType"

    displayObjects $blobType
}

function showWorkingArea()
{
    get-childitem -Exclude .git | get-childitem -Recurse
}

function delimitmsg($msg)
{
    $delimitS = "************************* "
    $delimitE = " *************************"

    Write-Host -ForegroundColor Red $delimitS ("{0,-30}" -f $msg) $delimitE
}

#endregion

# Git 101

cd $TrainingRootFolder

# Create new folder (cleaning up any existing)

Remove-Item -path NewGitRepo -Force -Recurse
New-Item -Path NewGitRepo -ItemType Directory
cd .\NewGitRepo

# create a new empty repository

git init

# Check what git thinks is happening

git status

# Show history of what has happened

git log

# Check out what is happening with branches
# since we haven't added and committed anything yet, list is empty

# Local Repository

git branch

# Local and remote repository branches

git branch -a

<#********************************************************************
This is an Optional Extra Credit Section that should only be done
to show how to look at the objects that get created and learn about SHA1
We will zap the repository and start again at the end of this section.

Just introducing use of functions

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

echo "Hello JediOrder" | git hash-object -w --stdin

# Go look at what just happened

whatsUpGitLong

git commit -m "Commit Blob"

# Go look at what just happened

whatsUpGitLong

<#********************************************************************
End Optional Extra Credit Section
**********************************************************************#>

# Ok, lets pretend we didn't do any of that
# Start Clean

cd $TrainingRootFolder

# Create new folder (cleaning up any existing)

Remove-Item -path NewGitRepo -Force -Recurse
New-Item -Path NewGitRepo -ItemType Directory
cd .\NewGitRepo
get-childitem -recurse

git init

get-childitem -path .git -recurse

whatsUpGitLong

# Copy in contents of starting files from Git101Rep

cd $TrainingRootFolder\Git101Repo

cd $TrainingRootFolder\Git101Repo
git checkout Start
copy-item -Path .\recipies.txt -Destination ..\NewGitRepo
copy-item -Path .\Breakfast -Destination ..\NewGitRepo -Recurse
copy-item -Path .\Dinner -Destination ..\NewGitRepo -Recurse
cd $TrainingRootFolder\NewGitRepo

# What is in the Working Area?

showWorkingArea

# What does Git think is happening?

whatsUpGit

git add .

whatsUpGit

# Lets go and update the recipies.txt file and add eggs.txt and tacos.txt

cd $TrainingRootFolder\Git101Repo
showWorkingArea
git checkout FirstUpdate
showWorkingArea

copy-item -Path .\recipies.txt -Destination ..\NewGitRepo -Force
copy-item -Path .\Breakfast -Destination ..\NewGitRepo -Recurse -Force
copy-item -Path .\Dinner -Destination ..\NewGitRepo -Recurse -Force
cd $TrainingRootFolder\NewGitRepo

# What does git think happened

git status

git diff

# What do we see in .git and .git\objects

whatsUpGitLong

git add .

whatsUpGitLong

# All right, let's commit this 

git commit -m "First Commit"

# Now what does .git know

whatsUpGitLong

# Ok, a lot just happened.  Let's see if we can understand it
# Using our knowledge of object types

displayObjects commit
displayObjects tree
displayObjects blob

# Add Sandwich.txt to Lunch folder

cd $TrainingRootFolder\Git101Repo
showWorkingArea
git checkout SecondUpdate
showWorkingArea

copy-item -Path .\Lunch -Destination ..\NewGitRepo -Recurse -Force
cd $TrainingRootFolder\NewGitRepo


git add .
git commit -m "Add Sandwich.txt"

whatsUpGit

# Update recipies.txt to include the Sandwich

cd $TrainingRootFolder\Git101Repo
showWorkingArea
git checkout SecondUpdate
showWorkingArea

copy-item -Path .\recipies.txt -Destination ..\NewGitRepo -Force

cd $TrainingRootFolder\NewGitRepo

git add .
git commit -m "Update recipies.txt"

whatsUpGit

displayObjects commit
displayObjects tree
displayObjects blob

<#*********************************************************************************
    Git102
*********************************************************************************#>

# Clone a remote repository

cd $TrainingRootFolder

# Red Team

git clone $VikramjeetGitHub/VikramJeetRedTeam.git
git clone $KrishanGitHub/KrishanRedTeam.git

# Green Team

git clone $GyanGitHub/GyanGreenTeam.git
git clone $PushpGitHub/PushpGreenTeam.git


# Blue Team

git clone $RohiniGitHub/RohiniGitHub.git
git clone $AjayGitHub/AjayGitHub.git


# Purple Team

git clone $ChristopherGitHub/PurpleTeam.git

# Push to a (empty) Remote Repository

git remote add origin https://github.com/chrhodes/GitTraining.git

git remote -v


