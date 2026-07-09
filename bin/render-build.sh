set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate

echo "=== Checking if seed data exists ==="
if bundle exec rails runner "exit(MoodRecord.exists? ? 0 : 1)"; then
  echo "Data already exists. Skipping seeds."
else
  echo "No data found. Running seeds..."
  bundle exec rails db:seed
fi