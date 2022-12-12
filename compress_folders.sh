#!/bin/bash
#     _    ____  
#    / \  / ___|   Alexandre Stanescot
#   / _ \ \___ \   http://alexstan67.github.io/profile/
#  / ___ \ ___) |  https://github.com/alexstan67/
# /_/   \_\____/ 
#
# Date:   06/12/2022
# Title:  Compress folders to work with rails template

echo -e "Removing compressed folders:"
if [ -e stylesheets.tar.gz ]
  then echo "✅ stylesheets.tar.gz successfully removed"
fi
if [ -e shared.tar.gz ]
  then echo "✅ shared.tar.gz successfully removed"
fi
if [ -e javascript.tar.gz ]
  then echo "✅ javascript.tar.gz successfully removed"
fi
if [ -e images.tar.gz ]
  then echo "✅ images.tar.gz successfully removed"
fi
if [ -e pages.tar.gz ]
  then echo "✅ pages.tar.gz successfully removed"
fi
echo -e "---"
echo -e "Creating compressed forlders:"
tar -czf stylesheets.tar.gz stylesheets
if [ -e stylesheets.tar.gz ]
  then echo "✅ stylesheets.tar.gz created successfully"
else
  echo "⛔ Error for stylesheets.tar.gz"
fi
tar -czf shared.tar.gz shared
if [ -e shared.tar.gz ]
  then echo "✅ shared.tar.gz created successfully"
else
  echo "⛔ Error for shared.tar.gz"
fi
tar -czf javascript.tar.gz *.js
if [ -e javascript.tar.gz ]
  then echo "✅ javascript.tar.gz created successfully"
else
  echo "⛔ Error for javascript.tar.gz"
fi
tar -czf images.tar.gz images
if [ -e images.tar.gz ]
  then echo "✅ images.tar.gz created successfully"
else
  echo "⛔ Error for images.tar.gz"
fi
tar -czf pages.tar.gz pages
if [ -e pages.tar.gz ]
  then echo "✅ pages.tar.gz created successfully"
else
  echo "⛔ Error for pages.tar.gz"
fi
