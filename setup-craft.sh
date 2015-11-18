#!/bin/sh

# Script to install and set up Craft CMS locally

# Author: Bob Orchard
# Website: http://boborchard.com

# THIS SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Ask for the administrator password upfront
sudo -v

echo " "
echo "-----------------------------------------------------"
echo "Please enter your project name (if mysite.dev, only"
echo "type 'mysite'.)"
echo "-----------------------------------------------------"
read project_name

git clone https://github.com/scotch-io/scotch-box.git $project_name
cd $project_name

echo " "
echo "-----------------------------------------------------"
echo "Please enter an IP address for this project: "
echo "Recommended: 192.168.88.x"
echo "-----------------------------------------------------"
read project_ip

echo " "
echo "-----------------------------------------------------"
echo "Updating your Vagrantfile..."
echo "-----------------------------------------------------"
mv vagrantfile vagrantfile.txt
sed -i '' "s/192.168.33.10/$project_ip/" vagrantfile.txt
mv vagrantfile.txt Vagrantfile
echo "Done."

echo " "
echo "-----------------------------------------------------"
echo "Starting Vagrant..."
echo "-----------------------------------------------------"

vagrant up

echo "Vagrant is now running."

echo " "
echo "-----------------------------------------------------"
echo "Updating your host file to point $project_name.dev to"
echo "$project_ip..."
echo "-----------------------------------------------------"
sudo -- sh -c "echo $project_ip  $project_name.dev >> /etc/hosts"
echo "Done."

echo " "
echo "-----------------------------------------------------"
echo "Grabbing the latest version of Craft and unloading it"
echo "into the current directory..."
echo "-----------------------------------------------------"
wget -O craft.zip https://buildwithcraft.com/latest.zip?accept_license=yes --no-check-certificate
rm -rf public
unzip craft.zip

rm -rf craft.zip readme.txt public/web.config
echo "cleaning up"

mv public/htaccess public/.htaccess
echo "renaming htaccess to .htaccess"

echo "Done."

echo " "
echo "-----------------------------------------------------"
echo "Updating your Craft config file: "
echo "-----------------------------------------------------"
echo "<?php
return array(
  'server' => 'localhost',
  'user' => 'root',
  'password' => 'root',
  'database' => 'scotchbox',
  'tablePrefix' => 'craft',
);" > craft/config/db.php
echo "Done."

echo " "
echo "-----------------------------------------------------"
echo "Removing the git repo we used to install & prepare "
echo "the Vagrant box"
echo "-----------------------------------------------------"
rm -rf .git
echo "Done."

echo " "
echo "-----------------------------------------------------"
echo "All set - opening Atom & your new site"
echo "-----------------------------------------------------"

atom .
open "http://$project_name.dev/admin"
