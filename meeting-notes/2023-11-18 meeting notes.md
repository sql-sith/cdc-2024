# Bash Shell Q&A

From Cyber Defense Meeting, 18-Nov-2023

<table>
  <tr>
    <th align="right">Location:</th>
    <td>GoDaddy Cedar Rapids Office</td>
  </tr>
  <tr>
    <th align="right">In Attendance:</th>
    <td>Henry, Michael, Tristan, Dan, and Chris</td>
  </tr>
  <tr>
    <th align="right">Missed Like the Iowa<br/>Offense Against Penn State:</th>
    <td>Aksel and Josh</td>
  </tr>
  <tr>
    <th align="right">Noteworthy findings:</th>
    <td>
        It wasn't all about Linux today. We also learned some interesting things about each other.
        <br/><br/>
        <ul>
            <li>Tristan and Dan were hungry. They view an operating system (OS) as a taco, and OS shells as, well, the shell. For Tristan, I suspect that ongoing hunger is his natural "ground state."</li>
            <li>Henry is named Henry, and is either a regular wizard or, possibly, a necromancer. He is also named Henry.</li>
            <li>Michael seems highly motivated about about the topic "confusing young children."</li>
            <li>Chris used to own Village People albums on 8-Track.</li>
        </ul>
    <br/>
    We may want to keep this kind of trivia in mind in case there are informal end-of-year awards.
    </td>
  </tr>
</table>

## Q&A Question 1: What is a Shell?

We started off with Q&A, asking everybody for a short, unprepared answer to the question, "What is a shell?"

- Tristan: an API funnel point for the OS
- Michael: something that allows you to interface with an OS at a more lower level
- Dan: an overlay of the OS, and a thing you can put meat, lettuce, and cheese in, along with salsa
- Henry: the non-GUI way of interacting with the OS

### What is a Shell? Post-meeting Comments

What I like about your answers is that, taken together, they point out the following:

- Shells allow you to interact (interface) with the operating system (OS).
- Shells abstract (overlay) what the OS can do by giving you an interface.
- CLI shells generally give you a more detailed way to interact with the OS than graphical shells and apps do.
- Shells consolidate (funnel)
- To be fair, while shells can be graphical (Windows, macOS, Gnome, KDE), I usually call those "graphical shells."
  - When I refer to shells, it's pretty safe to say that I am referring to command-line (non-GUI) shells that can be run from a terminal.
  - Such shells are called Command-Line Interfaces, or CLIs for short.

> ### Sidebar: `sh` doesn't exist
>
> It's a little sensationalistic to say that `sh` doesn't exist, when there is a program at `/bin/sh` on every Linux OS. What I mean is that, except for the original (proprietary) Unices, `sh`, in open-source *nixes, is really a copy of, or a link to, some other program.
>
> This makes for and interesting situation, where lots of people who think they know their OS's default shell are flat-out wrong. If you don't like confusion, you might want to skip this section.
>
> If you ask an Ubuntu user what Ubuntu's default shell is, most will probably say that it's `bash`. If you ask a macOS user what that OS's default shell is, most will (in their naturally bourgie manner, of course) point out that they have left `bash` behind to let it die in Neanderthal obscurity, and that macOS now embraces the obviously superior `zsh` as its default shell.
>
> Well, hardy-har-har, the joke's on them.
>
> According to the POSIX standard, the system's default shell must (among other things) be an executable located at `/bin/sh`. This means that one way to determine a system's default shell is to simply determine what program is stored at `/bin/bash`. Observe.
>
> On a Macbook Air:
>
> ```bash
> chris@MacBook-Air ~ % sh --version
> sh --version
> GNU bash, version 5.0.17(1)-release (x86_64-pc-linux-gnu)
> Copyright (C) 2019 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
>
> This is free software; you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.
> ```
>
> Notice that line 3 begins with the words `GNU bash`. That's right, the default shell on macOS is, in fact, shell that our hypothetical macOS user just threw shade at as an obscure, Neandarthal menace: `bash`.
>
> If you try the same syntax on `Ubuntu`, you get an error:
>
> ```bash
> chris@caerdydd:~$ sh --version
> sh: 0: Illegal option --
> ```
>
> Rather than try to get this program to tell us its version, the better way to do this is to use the `man` pages. Below I have listed first part of the output from `man sh` on Ubuntu. Notice that the shell name is `dash `. The `dash` shell is faster than `bash` at certain low-level operations, and is used by many, if not all, Debian-based Linux distributions.
>
> ```bash
> chris@caerdydd:~$ man sh
>
> DASH(1)                                             BSD General Commands Manual                                             DASH(1)
>
> NAME
> dash — command interpreter (shell)
>
> SYNOPSIS
> dash [-aCefnuvxIimqVEbp] [+aCefnuvxIimqVEbp] [-o option_name] [+o option_name] [command_file [argument ...]]
> dash -c [-aCefnuvxIimqVEbp] [+aCefnuvxIimqVEbp] [-o option_name] [+o option_name] command_string [command_name [argument ...]]
> dash -s [-aCefnuvxIimqVEbp] [+aCefnuvxIimqVEbp] [-o option_name] [+o option_name] [argument ...]
>
> DESCRIPTION
> dash is the standard command interpreter for the system.  The current version of dash is in the process of being changed to conform with the POSIX 1003.2 and 1003.2a specifications for the shell.  This version has many features which make it appear similar in some respects to the Korn shell, but it is not a Korn shell clone (see ksh(1)).  Only features designated by POSIX, plus a few Berkeley extensions, are being incorporated into this shell.  This man page is not intended to be a tutorial or a complete specification of the shell.
> ```
>

The reason for the confusion is that the default shell for a _user_ in macOS is `zsh`, and the default _user_ shell in Ubuntu is `bash`. But if a script wants to be run by the system shell, it will be run by `bash` in macOS, and `dash` in Ubuntu. Isn't life weird?

### Back to the question, "What is a shell?"

I didn't answer the question. I thought since I'd been thinking about it for half a week, it might not be fair. But we did present Bard and Bing/ChatGPT (in creative mode) the following prompt: "Hi, (Bard|Bing)! It's Chris. How would you define an operating system shell, at a high school senior level, in one brief paragraph?"

- Bard: An operating system shell is a software interface that acts as a bridge between a user and the core of an operating system. It enables users to control and interact with the system by interpreting commands entered in a text-based or graphical environment. Think of it as the command center of your computer, allowing you to manage files, launch programs, and configure system settings.
- ChatGPT: An operating system shell is a program that allows you to communicate with the operating system and use its services. You can type commands or click icons to tell the operating system what you want to do, such as creating, deleting, or moving files, running other programs, or changing settings. The shell is the outermost layer of the operating system, because it is the part that you see and interact with. [Different operating systems may have different types of shells, such as command-line shells or graphical shells](https://en.wikipedia.org/wiki/Shell_%28computing%29)

These are pretty good answers. ChatGPT even gave examples of different things that shells can do, which took some of the fun out of my next question...

## Q&A Question 2: What are shells used for?

This section will have user comments and post-meeting notes mixed together.

- Henry: Wizardry

  - necromancy
  - orchestration
  - aliases
  - functions
  - scripting

    _NOTE: The definition of "wizardry" expanded over time to include any kind of programming, because people who can code look a lot like magicians to people who can't._
<br/>
- Dan: is still hungry and talking about tacos
- Chris: file management
  - crud (create, read, update, delete), and untrash
  - access control/permissions
- Dan: launching files

  - interpreters to run scripts
  - compiled programs
  - debugging
- Michael: confusing young children
  - *For the record, I usually **trust** Eagle Scouts*
- Tristan: managing and customizing an OS

  - adding and managing services
  - adding and managing packages
  - configuring OS properties
  - viewing log files
- Dan: Workflow management

  - Job management
  - Pipelining
  - Scheduling
  
    _NOTE: This isn't exactly what Dan was after, but I had trouble capturing his ideas in a bullet point. He was pointing out how shells can be used to take complicated, multi-step processes and make them seem simpler._
<br/>

## `PowerShell` vs `bash`

### Everything in `PowerShell` is an Object

The first thing I mentioned today was actually why I wanted to look at `bash` before talking about `PowerShell`. I gave a demo that emphasized that everything in `PowerShell` is a programming object. For example, if you run `dir` on a file, `PowerShell` doesn't just print the directory listing, it actually retrieves API information about the file. Because you don't tell it to do anything else with the option, the `dir` command performs its default option, which is to display the information as a directory listing.

> _NOTE: `dir` is an alias for the `Get-ChildItem` cmdlet. In `PowerShell`, executable names follow a `verb-noun` naming convention, but many of them have aliases. When using the shell interactively, it's considered OK to use aliases. However, when writing scripts, you should use the actual command name, such as `Get-ChildItem` instead of `dir`._

Since `PowerShell` holds a programming object representing that file, you can tell it to take other actions on that object besides just printing a directory-style report. In fact, you have access to all of the properties and methods of that object. Here is a short demo script that shows some of this capability.

```PowerShell
[2023-Nov-18 16:36:18.314] [W:\home\chris\demo]
 > Get-ChildItem .\file-01.txt | Select-Object

    Directory: W:\home\chris\demo

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-----           1/14/2023 11:17 AM            216 file-01.txt


[2023-Nov-18 16:37:11.744] [W:\home\chris\demo]
 > Get-ChildItem .\file-01.txt | Select-Object -Property DirectoryName, BaseName, Extension, IsReadOnly, Length

DirectoryName : W:\home\chris\demo
BaseName      : file-01
Extension     : .txt
IsReadOnly    : False
Length        : 216
```

This is a very simple demonstration, but it shows that `PowerShell` has access to properties of the file that can be explicitly named, such as `DirectoryName` and `Length`.

`Powershell` fits Windows "like a glove" because it interacts with Windows and .NET APIs. There is a newer version of `PowerShell` that is platform-neutral (and runs on Linux) but is still an object-oriented shell.

Since everyone on the team knows some sort of programming, I expect that `PowerShell` will make some sense as soon as we start using it.

### Everything in `bash` is text

In `bash`, on the other hand, almost everything is just a bunch of text. This seems like the most natural thing in the world if your first operating system was one of the *BSDs, one of the *nices, or anything similar, but it can feel like an insult if you come from macOS or Windows. However, there is a good reason for this.

We looked at how everything in Linux is a file. And while I'm not sure that absolutely 100 percent of everything has a file representation in Linux, I wouldn't be surprised. Some of the things that are represented by files can be surprising the first time you find them. Here are some examples:

```
# Demo 1: What Is The Mount Point For The / Folder?

root@palo:~# cat /proc/mounts | grep ' / '
/dev/sda3 / ext4 rw,relatime,errors=remount-ro 0 0

# So / is mounted on something called /dev/sda3. What is that?

root@palo:~# ls -l /dev/sda3
brw-rw---- 1 root disk 8, 3 Nov  9 22:35 /dev/sda3

# Why, it's a file! :) It's type is 'b' (that's the first column). 'b' means it's a 
# "block special" file. disks store data in blocks, so that makes sense. You can think
# of this file as something similar to a device driver in Windows.

# Demo 2: Working with terminals

root@palo:~# ps
    PID TTY          TIME CMD
  62366 pts/1    00:00:00 sudo
  62367 pts/1    00:00:00 bash
  62614 pts/1    00:00:00 ps

# I am on pseudo-terminal 1 (pts/1). Is there a file for that? I'm glad you asked!

root@palo:~# ls -l /dev/pts/1
crw------- 1 root tty 136, 1 Nov 18 17:02 /dev/pts/1

# This one is a character special file (type c). # Since it's my terminal, what happens
# if I write to it? Will it just get redirected to my screen?

root@palo:~# echo Will this show up on my screen? >> /dev/pts/1
Will this show up on my screen?

# That works! (Note that I am root, the file's owner. That's why it works.)

# Demo 3: Information about processes

# Process 1 is the process that loaded Linux. What was its command line?

root@palo:~# cat /proc/1/cmdline 
/sbin/initsplash

# $$ is an environment variable that returns the current process ID. WHat's my current PID?

root@palo:~# echo $$
63087

# What is the maximum number of files that can be opened by the current process? Note that 
# 63087 is just an example PID from my previous command. You can run `cat /proc/$$/limits`
# instead and `bash` will substitute the current process ID where `$$` appears.

root@palo:~# cat /proc/63087/limits
Limit                     Soft Limit           Hard Limit           Units     
Max cpu time              unlimited            unlimited            seconds   
Max file size             unlimited            unlimited            bytes     
Max data size             unlimited            unlimited            bytes     
Max stack size            8388608              unlimited            bytes     
Max core file size        0                    0                    bytes     
Max resident set          unlimited            unlimited            bytes     
Max processes             15332                15332                processes 
Max open files            1024                 1048576              files     
Max locked memory         512180224            512180224            bytes     
Max address space         unlimited            unlimited            bytes     
Max file locks            unlimited            unlimited            locks     
Max pending signals       15332                15332                signals   
Max msgqueue size         819200               819200               bytes     
Max nice priority         0                    0                    
Max realtime priority     0                    0                    
Max realtime timeout      unlimited            unlimited            us 

```

## Housekeeping

- There will be no meeting next Saturday, 25-Nov-2023. I hope you all have a great Thanksgiving week with your families.
  - We'll meet again on Saturday, 2-Dec-2023.
  - Also, Henry, I hope everything goes well for your Mom and family regarding child number 11/daughter number 6!
- There will be homework. If I can do it the way I want to, it will be a set of tasks to do in the `bash` shell. For each task, I will tell you what commands can be used to accomplish the task.
- I have not forgotten about making a DNS server in the ISEAGE network so that you can have an accessible DNS server to forward requests to. I should have time during this two-week period to take care of that.