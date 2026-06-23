You completed a test/review task.

## If PASS

Run:
```
vibmax pass <this-issue-id>
```

Done. No further action needed.

## If FAIL

Run:
```
vibmax reject <this-issue-id> <<'EOF'
Your review report: what issues you found, what needs to be fixed...
EOF
```

The reject script will create a new do+test pair with your review report.
