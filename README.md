# scripts
Collection of various shell scripts to help automate the development and the deployment of software architectures


## SSH keys setup 
### Creating new ones
```bash

ssh-keygen -t ed25519 -C "dinies@foo.com" -f ~/.ssh/id_foobar
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_foobar
```
Then add the key in the website.

### Import existing ones
```bash
cd ~                          ;\
mkdir .ssh                    ;\
touch  ~/.ssh/id_github       ;\
touch  ~/.ssh/id_github.pub   ;\
touch  ~/.ssh/id_gitlab       ;\
touch  ~/.ssh/id_gitlab.pub   
```
Then manually copy the content of the ssh keys inside the corresponding files
Finally change the permissions and add the ssh keys to the ssh-agent:

```bash
chmod 600 id_github           ;\
chmod 600 id_gitlab           ;\
eval "$(ssh-agent -s)"        ;\
ssh-add ~/.ssh/id_github      ;\
ssh-add ~/.ssh/id_gitlab     
```

