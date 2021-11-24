# Configure your paths and filenames
SOURCEBINPATH=$(pwd)
SOURCEBIN=setup.sh
DEBFOLDER=$(pwd)/debian
DEBVERSION=0.1

DEBFOLDERNAME=$DEBFOLDER-$DEBVERSION

# Create your scripts source dir
mkdir $DEBFOLDERNAME

# Copy your script to the source dir
cp $SOURCEBINPATH/$SOURCEBIN $DEBFOLDERNAME
cd $DEBFOLDERNAME

# Create the packaging skeleton (debian/*)
dh_make -s --indep --createorig

# Remove make calls
grep -v makefile debian/rules > debian/rules.new
mv debian/rules.new debian/rules

# debian/install must contain the list of scripts to install
# as well as the target directory
echo $SOURCEBIN usr/bin > debian/install

# Remove the example files
rm debian/*.ex

# Build the package.
# You  will get a lot of warnings and ../somescripts_0.1-1_i386.deb
debuild -d --check-dirname-level 0 -us -uc
