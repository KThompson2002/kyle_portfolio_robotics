set -e
rm -rf public
hugo --gc --minify
cd public
git add .
git commit -m "Deploy $(date)"
git push origin main
cd ..