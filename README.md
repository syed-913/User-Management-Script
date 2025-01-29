# User Management Script

This is an enhanced **Bash script** for managing users in a Linux environment, specifically tailored for enterprise use. It provides a robust set of features for creating, modifying, and deleting users, as well as managing user groups and enforcing strong password policies. The script is designed to be secure, user-friendly, and compliant with enterprise standards.

---

## Features

1. **User Creation**:
   - Create new users with a choice of shell (`bash` or `zsh`).
   - Enforces strong password policies:
     - Minimum 8 characters.
     - Requires uppercase letters, numbers, and special characters.

2. **User Deletion**:
   - Delete users along with their associated groups and home directories.
   - Confirmation prompt to prevent accidental deletions.

3. **User Modification**:
   - **Lock/Unlock Users**: Temporarily disable or enable user accounts.
   - **Change Passwords**: Securely change user passwords with strong password enforcement.
   - **Change Primary Group**: Modify the primary group of a user, with the option to create new groups if they don't exist.

4. **User Listing**:
   - List all users with their details, including:
     - User ID (UID)
     - Group ID (GID)
     - Home directory
     - Login shell

5. **Logging**:
   - All actions are logged to `/var/log/user_management.log` for audit purposes.
   - Logs include timestamps, event types (e.g., SUCCESS, ERROR), and detailed messages.

6. **User Experience**:
   - Interactive prompts for user input.
   - Loading animations for better feedback during operations.

---

## Usage

### 1. **Running the Script**
To use the script, simply execute it in a Bash shell:

```bash
sudo ./User_management.sh
```

> **Note**: The script requires root privileges to perform user management tasks.

### 2. **Main Menu**
The script provides a menu-driven interface with the following options:

- **1. Add User**: Create a new user with a strong password and a choice of shell.
- **2. Remove User**: Delete a user, their group, and home directory.
- **3. Modify User**: Modify user attributes (lock/unlock, change password, change primary group).
- **4. List Users**: Display a list of all users with their details.
- **0. Exit**: Exit the script.

### 3. **Logging**
All actions performed by the script are logged to `/var/log/user_management.log`. This log file is created automatically if it doesn't exist, and it includes timestamps and event details for auditing purposes.

---

## Example Workflow

### **Creating a New User**
1. Select option **1** from the main menu.
2. Enter the username and a strong password (minimum 8 characters, with uppercase, numbers, and special characters).
3. Choose the login shell (`bash` or `zsh`).
4. The user is created, and the action is logged.

### **Deleting a User**
1. Select option **2** from the main menu.
2. Enter the username to delete.
3. Confirm the deletion.
4. The user, their group, and home directory are removed, and the action is logged.

### **Modifying a User**
1. Select option **3** from the main menu.
2. Choose from the following sub-options:
   - **Lock/Unlock User**: Temporarily disable or enable a user account.
   - **Change Password**: Update the user's password with strong password enforcement.
   - **Change Primary Group**: Modify the user's primary group, with the option to create a new group if it doesn't exist.
3. The changes are applied, and the action is logged.

### **Listing Users**
1. Select option **4** from the main menu.
2. A table of all users is displayed, showing their UID, GID, home directory, and login shell.

---

## Security Features

- **Strong Password Enforcement**: Ensures all passwords meet enterprise security standards.
- **Audit Logging**: All actions are logged for compliance and security auditing.
- **Confirmation Prompts**: Prevents accidental deletions or modifications.

---

## Log File Example

The log file (`/var/log/user_management.log`) records all actions with timestamps and event types. Here's an example of what the log might look like:

```
[01-Oct-2023 14:30:45] [SUCCESS] New user 'john' created in BASH shell
[01-Oct-2023 14:31:10] [ERROR] Failed to change the password of user 'john'
[01-Oct-2023 14:32:00] [INFO] The 'developers' group is now the group owner of all the files owned by 'john'
```

---

## Requirements

- **Bash Shell**: The script is written for Bash and should be run in a Bash environment.
- **Root Privileges**: The script requires root access to perform user management tasks.
- **Linux Environment**: Designed for Linux systems with standard user management tools (`useradd`, `usermod`, `userdel`, etc.).

---

## Contributing

Contributions are welcome! If you'd like to improve this script, feel free to:

1. Fork the repository.
2. Make your changes.
3. Submit a pull request.

---

## Author

Syed Ammar
Email: syedammar06@proton.me

---

Enjoy managing users with this powerful and secure script! 🚀
