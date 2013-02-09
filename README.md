Expression Engine permissions utility
=====================================

This is a simple BASH script to automate the process described by the
[Expression Engine documentation](http://ellislab.com/expressionengine/user-guide/installation/installation.html).  It's so annoying to have to check this page every single time, and enter half a dozen commands or better...
This script makes all the pain go away!!

All you have to do is download the script, then set it to executable

`chmod u+x set-ee-perms.sh`

From there, you're ready to use the script on any freshly unpacked EE installation.

Using the script is simple.  The first argument specifies the root of the EE installation.
The second shell argument indicates the user & group to set the ownership to.
If the group is different than the user, the third argument allows you to specify the different group name.

### External system directory

For those of you who want to secure your installation by moving the system directory outside the webroot of your project as described in the [best practices doc](http://ellislab.com/expressionengine/user-guide/installation/best_practices.html),
just run the script before moving out the system directory and you'll be golden.

Examples
--------

Assume _set-ee-perms.sh_ is in your home directory & the working directory is the EE installation directory.

`~/set-ee-perms.sh . apache # Set ownership to apache:apache`

Assume the group is going to be different

`~/set-ee-perms.sh . apache root # Set ownership to apache:root`

Assume the current directory is not the EE root & the EE root is in _/var/www/my-ee-site_

`~/set-ee-perms.sh /var/www/my-ee-site apache`
