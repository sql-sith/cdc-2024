# HOWTO: Install Windows Server 2002 in vSphere

## Install a New VM in ISERINK

- Right click **School 14** and choose `New Virtual Machine`.
- In the **Select a creation type** panel, click `Create a new virtual machine` and click `Next`.
- In the **Select a name and folder** panel, do the following:
  - Enter a name for your VM. This is the name that will appear in VSphere.
  - Expand the folders in the frame on the lower-right, and click on the `School 14` folder.
  - Click `Next`.
- In the **Select a compute resource** panel, ensure `School 14` is selected on the right, and click `Next`.
- In the **Select storage panel**, choose `Highschool Storage` and click `Next`.
- In the **Select compatibility** panel, leave the compatability level at the default and click `Next`.
- In the **Select a guest OS** panel, do the following:
  - Set the **Guest OS Family** to `Windows`.
  - Set the **Guest OS Version** to `Microsoft Windows Server 2022 (64-bit)`.
  - Click Next.
- In the **Customize hardware** panel, do the following:
  - Set the **Memory** to `2 GB`*.
  - Set the **New hard disk** size to `256 GB`.
  - Set the New CD/DVD Drive to Datastore ISO File.
    - Choose the `SERVER_EVAL_x64FRE_en-us.iso` from the `Playground ISO Datastore`.
    - This ISO may be renamed soon. If it is, it is the `Windows Server 2022` ISO that is 4.7 GB in size.
  - Click `Next`.
- Finally, in the Ready to complete panel, review the summary. If you want to change anything, you can click on the panel heading on the left to jump to that panel directly and make the change, and then click on Ready to complete to jump back to this panel. When you are satisfied that everything is ready, click `Finish`.

> \* VSphere says that the minimum for Windows Server 2022 is 512 MB, but we know that won't work. I want us to build servers that use the same amount of RAM as the ones the competition gives us, but I don't know how much we really need. If anyone remembers how much RAM the competition uses on a .

## Install Windows Server 2022

- Power up your VM.
- You will need to press a key to get the VM to boot from the Windows ISO.
  - If you don't get to it in time, just click the `Send Ctrl+Alt+Del` button in the web console to give it another go.
- After the Windows graphical installer starts, do the following:
  - In the initial dialog, do the following:
    - Ensure that **Language to install** is set to `English (United States)`.
    - Ensure that **Time and currency format** is set to `English (United States)`.
    - Ensure that **Keyboard or input method** is set to `US`.
    - Click `Next`.
  - In the next dialog, click the `Install now` button.
  - In the **Select the operating system you want to install** dialog, choose `Windows Server 2022 Standard Edition Desktop Edition`.

> Resist the temptation to install `Windows Server 2002 Standard Edition` (aka, `Windows Server Core` - the one without the Desktop) until you get pretty good with Windows, and especially until you get good at managing services using Windows PowerShell. This means installing, configuring, managing, starting, stopping, debugging, granting and revoking access to, and doing everything else you might do to a service, all through PowerShell. It's best for you at this point, and best for the team since we're getting close to the competition, to walk before you try to run.

- On the **Applicable notices and license terms** screen, accept the terms and click `Next`.
- On the **Which type of installation do you want?** screen, choose the `Custom` option, even though the `Upgrade` option is selected by default. If you choose `Upgrade`, the installer will go back a few steps and make you repeat some clicks.
- On the **Where do you want to install the operating system?** screen, ensure that Drive 0 is selected and click `Next`.

At this point, the installer will run for almost to the point of completion. When it is nearly complete, there are some additional actions you will need to take.

- In the **Customize Settings** dialog, you need to provide a password for the `Administrator` user.
  - This password will have to meet the standard Windows complexity requirements:
    - It must be at least 8 characters long.
    - It must have at least 1 character from at least three of the following character classes:
      - Upper-case letters from European languages.
      - Lower-case letters from European languages.
      - Other Unicode characters that are alphanumeric but are not uppercase or lowercase.
        - Think: Chinese, Japanese, Korean,etc.
      - Non-alphanumeric characters: ``~!@#$%^&*_-+=`|(){}[]:;"'<>,.?/``
      - Base-10 digits.
- The cheap-but-compliant password to use if you just want to stick in a temporary password is `P@ssw0rd`.

## Renaming the Server After Installation

During the installation, the server will be given an arbitrary hostname like `WIN-97DUB9B83FR`. There are a few ways to rename a server. In addition to the **Rename this PC** button in the **System** settings, you can also do this using **Server Manager** or **PowerShell**.

### Rename the Server with Server Manager

- Open Server Manager.
- Click Local Server on the left pane.
- Under Properties, click Computer name.
- Click the Change button.
- Enter your desired new name in the Computer name field.
- Click OK twice.
- Click Restart Now to apply the changes.

### Rename the Server Using PowerShell

- Open PowerShell as Administrator.
- Run `Rename-Computer -NewName <NewServerName>`` -Force
  - Replace `<NewServerName>` the name you want to use.
- Run `Restart-Computer -Force` to restart the server.

## Install VMWare Tools on the VM

Installing VMWare Tools on the Windows instance will improve the resolutions used in the web console. To install the tools, do the following.

- In vSphere, right-click the VM and select Guest OS > Install VMware Tools.
- In the Install VMWare Tools dialog, click Mount.
- The VM will mount the VMware Tools installer.
- On the guest OS (Windows Server 2022), a CD drive with the installer should appear.
- Open the CD drive and run setup64.exe.
  - Pro tip: the installer may appear under other windows. If this happens, you'll see it on the task bar when it launches and then you'll know to uncover it to continue the installation.
- Follow the on-screen prompts to complete a typical installation.
- Reboot the VM for changes to take effect.
