# Installing and Using Semgrep

> Note: if using Windows, you should install Semgrep inside WSL. Semgrep does not run in the normal Windows CLI environment.

## Prerequisites

- Current (supported) version of Linux, macos, or WSL
- Current (supported) version of Python

## Install Semgrep

Install Semgrep using `pip`:

```bash
$ python -m pip install semgrep
Collecting semgrep
  Downloading semgrep-1.66.0-cp38.cp39.cp310.cp311.py37.py38.py39.py310.py311-none-any.whl (27.0 MB)
     |████████████████████████████████| 27.0 MB 6.5 MB/s
< etc. >
Installing collected packages: <lots of package names>
```

## Get a Code Repository to Scan

You can scan any source code you want to. Scanning your own is a best practice. In the competition, we'll have real servers to scan so we'll have apps on them (and hopefully source code to scan).

For practice, you can download repositories from places like GitHub to scan. Intentionally vulnerable repos like Juice Shop are especially useful, and I will use Juice Shop as an example.

Install `git` first if needed and then clone the Juice Shop repo.

```plaintext
$ git clone https://github.com/juice-shop/juice-shop.git
Cloning into 'juice-shop'...
remote: Enumerating objects: 130293, done.
remote: Total 130293 (delta 0), reused 0 (delta 0), pack-reused 130293
Receiving objects: 100% (130293/130293), 233.06 MiB | 16.57 MiB/s, done.
Resolving deltas: 100% (101425/101425), done.
```

## Scan the Repo

Now you can use semgrep to scan the repository. Start by changing directories to the location of the code you want to scan. THis isn't necessary, but it simplifies the command line a little bit.


```plaintext
# simple semgrep scan of current directory tree:
$ semgrep scan .

┌──── ○○○ ────┐
│ Semgrep CLI │
└─────────────┘

Scanning 1150 files (only git-tracked) with:

✔ Semgrep OSS
  ✔ Basic security coverage for first-party code vulnerabilities.

✘ Semgrep Code (SAST)
  ✘ Find and fix vulnerabilities in the code you write with advanced scanning and expert security rules.

< etc. >

┌──────────────┐
│ Scan Summary │
└──────────────┘
Some files were skipped or only partially analyzed.
  Partially scanned: 30 files only partially analyzed due to parsing or internal Semgrep errors
  Scan skipped: 8 files larger than 1.0 MB, 137 files matching .semgrepignore patterns
  For a full list of skipped files, run semgrep with the --verbose flag.

Ran 306 rules on 979 files: 59 findings.
💎 Missed out on 737 pro rules since you aren't logged in!
⚡ Supercharge Semgrep OSS when you create a free account at https://sg.run/rules.
```

Running the scan creates a lot of output! The findings are all listed together in a section in the middle of the output.

You'll notice that the summary section at the end says that you "missed out on 737 pro rules since you aren't logged in!" If you run with the --debug parameter, you'll see that Semgrep considered 306 rules but ignored 737 rules. If you make a free account at Semgrep and run `semgrep login`, then the Semgrep engines will consider all 1043 rules.

For Juice Shop, logging onto Semgrep and rerunning the scan will result in 80 findings instead of 59 findings.

## Capturing Semgrep Output

You can use normal file redirection (`semgrep --parameters > /my/log/file`) to capture Semgrep output, or you can use its builtin `--output` parameter. However, these techniques only capture part of the program's output while other parts still display on the screen. The program tries to make reasonable choices about what you will actually want in a log file.

### A Note on Redirecting Semgroup Output

However, if you want to capture *all* program output to a file, you will have to redirect both *stdout* and *stderr* like this:

```plaintext
semgrep scan --config auto --verbose > /tmp/semgrep.log 2>&1
```

The redirects here work as follows:

- the first redirect (`>`) sends `stdout` to `/tmp/semgrep.log`
- the second redirect (`2>&1`) points `stderr` (file 2) to the current location of file 1 (which at this point has been redirected to `/tmp/semgrep.log`)
