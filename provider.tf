provider "aws" {
  region  = var.region
}

git init
git add .        
git commit -m "Add terraform scripts"
git branch -M master
git remote add origin git@github.com:GauravJain98/Mirror.git
git push -u origin master