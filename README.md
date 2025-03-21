# Soundness Testnet Auto-Install

This repository contains scripts to automate the installation and setup process for participating in the Soundness Testnet.

## Quick Start

1. Register for the Soundness Testnet:
   - Visit [https://soundness.xyz/](https://soundness.xyz/)
   - Submit your email address
   - Registration complete!

2. Run the auto-installer:
   ```bash
   wget https://raw.githubusercontent.com/dlzvy/soundness-auto/main/install.sh && chmod +x install.sh && ./install.sh
   ```

## Key Management Commands

After installation, you can use the following commands to manage your keys:

### Generate a New Key
```bash
soundness-cli generate-key --name YOUR_KEY_NAME
```
Replace `YOUR_KEY_NAME` with your preferred key name.

### List Your Keys
```bash
soundness-cli list-keys
```
**Important:** Make sure to save your public key information displayed by this command.

### Export Your Key Phrase
```bash
soundness-cli export-key --name YOUR_KEY_NAME
```
Replace `YOUR_KEY_NAME` with the name of the key you want to export.

**Important:** Store your key phrase securely. Never share it with anyone.

## Security Recommendations

- Always back up your key phrases in a secure location
- Do not share your private keys or phrases with anyone
- Use unique key names that are easy for you to remember

