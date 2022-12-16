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
if [ -e javascript.tar.gz ]
  then echo "✅ javascript.tar.gz successfully removed"
fi
if [ -e images.tar.gz ]
  then echo "✅ images.tar.gz successfully removed"
fi
if [ -e views.tar.gz ]
  then echo "✅ views.tar.gz successfully removed"
fi
if [ -e models.tar.gz ]
  then echo "✅ models.tar.gz successfully removed"
fi
if [ -e controllers.tar.gz ]
  then echo "✅ controllers.tar.gz successfully removed"
fi
echo -e "---"
echo -e "Creating compressed forlders:"
tar -czf stylesheets.tar.gz stylesheets
if [ -e stylesheets.tar.gz ]
  then echo "✅ stylesheets.tar.gz created successfully"
else
  echo "⛔ Error for stylesheets.tar.gz"
fi
tar -czf javascript.tar.gz javascript
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
tar -czf views.tar.gz views
if [ -e views.tar.gz ]
  then echo "✅ views.tar.gz created successfully"
else
  echo "⛔ Error for views.tar.gz"
fi
tar -czf models.tar.gz models
if [ -e models.tar.gz ]
  then echo "✅ models.tar.gz created successfully"
else
  echo "⛔ Error for models.tar.gz"
fi
tar -czf controllers.tar.gz controllers
if [ -e controllers.tar.gz ]
  then echo "✅ controllers.tar.gz created successfully"
else
  echo "⛔ Error for controllers.tar.gz"
fi
