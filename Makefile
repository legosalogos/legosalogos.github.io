# You must have jekyll and R installed, and they must be in PATH. For R, you
# need to install the servr package.

all:
	Rscript build.R

clean:
	rm -r ../_site
