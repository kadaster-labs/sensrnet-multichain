
# ensure we're up to date
git pull
# bump version
npm version patch --no-git-tag-version

VERSION=$(node -pe "require('./package.json').version")
echo "version: $VERSION"

rm VERSION
echo "$VERSION" >> VERSION

git add -A
git commit -m "release v$VERSION"
git tag -a "$VERSION" -m "release v$VERSION"
git push
git push --tags
