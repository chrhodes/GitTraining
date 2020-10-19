################################################################
# BD Jedi Order Git Training
################################################################

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

function displayConfig()
{
    get-content .\.git\config
}

# git cat-file
# Provides content or type and size information for repository objects

#git help cat-file
#git --help cat-file

# Displays information on objects
# Can limit by $blobType if passed, e.g. commit|tree|blob

function displaySha1Info([string] $sha1)
{
    delimitmsg SHA1
    $sha1

    delimitmsg "git cat-file -t"
    $blobtype = git cat-file $sha1 -t
    $blobtype

    #"sha1 $sha1 is a >>> " + (git cat-file $sha1 -t) + " <<<"

    # We have to rebuild, using the short form of the sha1,
    # a folder\filename so we can get the length

    $folder = $sha1.Substring(0,2)

    $filePrefix = $sha1.Substring(2)

    $file = get-item .\.git\objects\$folder\$filePrefix*

    delimitmsg "cat-file -p"

    switch($blobtype)
    {
        "commit" { git cat-file $sha1 -p ; break }
        "tree" { git cat-file $sha1 -p ; break }
        "tag" { git cat-file $sha1 -p ; break }
        default {

            if($file.Length -lt 500)
            {
                git cat-file $sha1 -p
            }
            else
            {
                "********** Content (" + $file.Length + ") > 500 bytes - Not Displayed **********"
            }
        }
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
            displaySha1Info $sha1
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
                displaySha1Info $sha1
                ""
            }
        }
    }
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

function displayHEAD()
{
    $head = (get-content .git\HEAD).Split(" ")
    delimitmsg "HEAD Contains"
    $head
    delimitmsg "SHA1"
    $path = $head[1]
    $sha1 = get-content .\.git\$path
    $sha1
    delimitmsg "get-content -t"
    git cat-file $sha1 -t
    delimitmsg "get-content -p"
    git cat-file $sha1 -p
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

    displaybranches

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

    displaybranches

    delimitmsg "displayObjects $blobType"

    displayObjects $blobType
}

function delimitmsg($msg)
{
    $delimitS = "************************* "
    $delimitE = " *************************"

    Write-Host -ForegroundColor Red $delimitS ("{0,-30}" -f $msg) $delimitE
}

function createRepo([string] $name)
{
    cd $TrainingRootFolder
    Remove-Item -path $name -Force -Recurse
    New-Item -Path $name -ItemType Directory
    cd .\$name
    git init
}

#endregion