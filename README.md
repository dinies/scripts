# scripts
Collection of various shell scripts to help automate the development and the deployment of software architectures

## git config set-up
```bash
git config --global user.name foo_name
git config --global user.email foo.bar@bar.com
git config --global push.default simple 
```
## SSH keys set-up 
### Creating new ones
The key name should be one of the predefined ones (one for each encoding).
If not then the key would not be offered automatically.
```bash
ssh-keygen -t ed25519 -C "bar@foo.com" -f ~/.ssh/id_ed25519
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```
Then add the key in the website.

### Import existing one
```bash
mkdir  ~/.ssh                 ;\
touch  ~/.ssh/id_ed25519      ;\
touch  ~/.ssh/id_ed25519.pub
  
```
Then manually copy the content of the ssh key inside the corresponding files
Finally change the permissions and test the connection to populate the known\_hosts list:

```bash
chmod 600 ~/.ssh/id_ed25519
chmod 600 ~/.ssh/id_ed25519.pub   
ssh -Tv git@github.com	      
ssh -Tv git@gitlab.inria.fr
ssh -Tv git@gitlab.com
```
