# scripts
Collection of various shell scripts to help automate the development and the deployment of software architectures


## SSH keys setup 
### Creating new ones
The key name should be one of the predefined ones (one for each encoding).
If not then the key would not be offered automatically.
```bash

ssh-keygen -t ed25519 -C "dinies@foo.com" -f ~/.ssh/id_ed25519
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```
Then add the key in the website.

### Import existing one
```bash
cd ~                          ;\
mkdir .ssh                    ;\
touch  ~/.ssh/id_ed25519      ;\
touch  ~/.ssh/id_ed25529.pub  ;\
```
Then manually copy the content of the ssh key inside the corresponding files
Finally change the permissions and add the ssh keys to the ssh-agent:

```bash
chmod 600 id_ed25519
```
