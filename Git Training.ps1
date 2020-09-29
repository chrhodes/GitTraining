################################################################
# BD Jedi Order Git Training
################################################################

################################################################
# Configure Information that may differ by each person's machine
################################################################

#region Configuration

$TrainingRootFolder = "C:\Training\Git"

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



################################################################
# NB.  Need to load these functions before starting to work.
################################################################

#region functions

# Displays content of .Git folder - The Git Repository!

function displayGitRepo()
{
    $objects = ".\.git"

    $objectFolders = get-childitem -Path $objects

    $objectFolders

    foreach ($fld in $objectFolders)
    {
        get-childitem -Path $objects\$fld -Recurse
    }
}

function displayWorkingArea()
{
    get-childitem -Exclude .git | get-childitem -Recurse
}

# git cat-file
# Provides content or type and size information for repository objects

git help cat-file
git --help cat-file

# Displays information on objects
# Can limit by $blobType if passed, e.g. commit|tree|blob

function displayBlobInfo([string] $sha1)
{
    "sha1 $sha1 is a >>> " + (git cat-file $sha1 -t) + " <<<"

    # We have to rebuild, using the short form of the sha1,
    # a folder\filename so we can get the length

    $folder = $sha1.Substring(0,2)

    $filePrefix = $sha1.Substring(2)

    $file = get-item .\.git\objects\$folder\$filePrefix*


    if($file.Length -lt 300)
    {
        "sha1 $sha1 contains: >>>" + (git cat-file $sha1 -p) + "<<<"
    }
    else
    {
        "********** Content > 300 bytes - Not Displayed **********"
    }

    ""
}

function displayObjects ($blobType = "")
{
    $sha1Folders = (getSHA1s)

   # $sha1Folders

    if($blobType -eq "")
    {
        "Showing all objects"

        foreach ($sha1 in $sha1Folders)
        {
            displayBlobInfo $sha1
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
                displayBlobInfo $sha1
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
        get-childitem -Path $objects\$fld -Recurse
    }
}

function displayBranches()
{
    delimitmsg "git branch -a"

    git branch -a

    $refs = ".\.git\refs"

    $refsFolders = get-childitem -Path $refs

    delimitmsg "refs\ contains"

    $refsFolders

    foreach ($fld in $refsFolders)
    {
        get-childitem -Path $refs\$fld -Recurse
    }

    ""
    delimitmsg "HEAD contains"
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

    delimitmsg "displayObjects $blobType"

    displayObjects $blobType
}

function delimitmsg($msg)
{
    $delimitS = "************************* "
    $delimitE = " *************************"

    Write-Host -ForegroundColor Red $delimitS ("{0,-30}" -f $msg) $delimitE
}

#endregion

#region Git 101

################################################################
# Git 101
################################################################

cd $TrainingRootFolder

# Create new folder (cleaning up any existing)

Remove-Item -path NewGitRepo -Force -Recurse
New-Item -Path NewGitRepo -ItemType Directory
cd .\NewGitRepo

#region Help

git help
git help -g
git help -a
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

#endregion

#region Optional Extra Credit - But let's do it anyway

<#********************************************************************
This is an Optional Extra Credit Section that should only be done
to show how to look at the objects that get created and learn about SHA1
We will zap the repository and start again at the end of this section.

Also introducing use of functions, infra

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

#endregion

# Ok, lets pretend we didn't do any of that
# Start Clean

cd $TrainingRootFolder

# Create new folder (cleaning up any existing)

Remove-Item -path NewGitRepo -Force -Recurse
New-Item -Path NewGitRepo -ItemType Directory
cd .\NewGitRepo
get-childitem -recurse

git init

# Let's see what is in a Git Repo (.git folder)

get-childitem -path .git -recurse

# Introduce whatsUpGitLong so we don't have to look in .git folder

whatsUpGitLong

# Copy in contents of starting files from Git101Rep

cd $TrainingRootFolder\Git101Repo
git checkout Start
copy-item -Path .\recipies.txt -Destination ..\NewGitRepo
copy-item -Path .\Breakfast -Destination ..\NewGitRepo -Recurse
copy-item -Path .\Dinner -Destination ..\NewGitRepo -Recurse
cd $TrainingRootFolder\NewGitRepo

# What is in the Working Area?

showWorkingArea

# What does Git think is happening?
# whatsUpGit is a little less verbose

whatsUpGit

# Note the difference between how git status behaves with untracked files

git status
git status --untracked-files

git add .

whatsUpGit

# We could do a commit right now, 
# but let's stage (add to index area) a few more files.

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
# Pay attention to the new files in the objest folder.  Any surprises?

whatsUpGitLong

git add .

whatsUpGitLong

# All right, let's commit this
# Normally we want the Date and Time but to make the demo consistent
# let's force the date

$today = get-date -DisplayHint Date
git commit -m "First Commit" --date=$today

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

#endregion

#region Git 102

<#*********************************************************************************
    Git102
*********************************************************************************#>

# Clone a remote repository

# NB. If this doesn't work, check that you are using the VPN

cd $TrainingRootFolder

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

# Push to a (empty) Remote Repository

git remote add origin https://github.com/chrhodes/GitTraining.git

git remote -v

# Get the GitTraining Repo
# You will start using this to create a mess

git clone $ChristopheGitHub/GitTraining.git

<#*********************************************************************************
    Hacking Around to greate Branches in GitTraining
    To start each team out with something to use.
*********************************************************************************#>

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


#endregion

#region Git 103

<#*********************************************************************************
    Git102
*********************************************************************************#>

#endregion


