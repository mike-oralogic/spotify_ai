# spotify_ai

Tools for analysing your Spotify Extended Streaming History data.

## Scripts

### `spotify_top_artists.py`

Displays your top artists by play count and total listening time.

**Usage:**

```bash
python3 spotify_top_artists.py [options]
```

**Options:**

| Flag | Description | Default |
|------|-------------|---------|
| `-n` | Number of top artists to display | `10` |
| `-d`, `--data-dir` | Path to directory containing Spotify JSON files | Configured path |

**Examples:**

```bash
# Show top 10 artists (default)
python3 spotify_top_artists.py

# Show top 25 artists
python3 spotify_top_artists.py -n 25

# Use a custom data directory
python3 spotify_top_artists.py -d "/path/to/Spotify Extended Streaming History/Audio"

# Combine options
python3 spotify_top_artists.py -n 20 -d "/path/to/data"
```

## Data

Expects Spotify Extended Streaming History JSON files in the format exported from your [Spotify account](https://www.spotify.com/account/privacy/). Files should be named `Streaming_History_Audio_*.json`.
