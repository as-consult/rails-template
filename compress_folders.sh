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
if [ -e mailers.tar.gz ]
  then echo "✅ mailers.tar.gz successfully removed"
fi
if [ -e db.tar.gz ]
  then echo "✅ db.tar.gz successfully removed"
fi
if [ -e config.tar.gz ]
  then echo "✅ config.tar.gz successfully removed"
fi
if [ -e helpers.tar.gz ]
  then echo "✅ helpers.tar.gz successfully removed"
fi
echo -e "---"
echo -e "Creating compressed forlders:"
tar -czf stylesheets.tar.gz --exclude="*.swp" stylesheets
if [ -e stylesheets.tar.gz ]
  then echo "✅ stylesheets.tar.gz created successfully"
else
  echo "⛔ Error for stylesheets.tar.gz"
fi
tar -czf javascript.tar.gz --exclude="*.swp" javascript
if [ -e javascript.tar.gz ]
  then echo "✅ javascript.tar.gz created successfully"
else
  echo "⛔ Error for javascript.tar.gz"
fi
tar -czf images.tar.gz --exclude="*.swp" images
if [ -e images.tar.gz ]
  then echo "✅ images.tar.gz created successfully"
else
  echo "⛔ Error for images.tar.gz"
fi
tar -czf views.tar.gz --exclude="*.swp" views
if [ -e views.tar.gz ]
  then echo "✅ views.tar.gz created successfully"
else
  echo "⛔ Error for views.tar.gz"
fi
tar -czf models.tar.gz --exclude="*.swp" models
if [ -e models.tar.gz ]
  then echo "✅ models.tar.gz created successfully"
else
  echo "⛔ Error for models.tar.gz"
fi
tar -czf controllers.tar.gz --exclude="*.swp" controllers
if [ -e controllers.tar.gz ]
  then echo "✅ controllers.tar.gz created successfully"
else
  echo "⛔ Error for controllers.tar.gz"
fi
tar -czf mailers.tar.gz --exclude="*.swp" mailers
if [ -e mailers.tar.gz ]
  then echo "✅ mailers.tar.gz created successfully"
else
  echo "⛔ Error for mailers.tar.gz"
fi
tar -czf db.tar.gz --exclude="*.swp" db
if [ -e db.tar.gz ]
  then echo "✅ db.tar.gz created successfully"
else
  echo "⛔ Error for db.tar.gz"
fi
tar -czf config.tar.gz --exclude="*.swp" config
if [ -e config.tar.gz ]
  then echo "✅ config.tar.gz created successfully"
else
  echo "⛔ Error for config.tar.gz"
fi
tar -czf helpers.tar.gz --exclude="*.swp" helpers
if [ -e helpers.tar.gz ]
  then echo "✅ helpers.tar.gz created successfully"
else
  echo "⛔ Error for helpers.tar.gz"
fi
