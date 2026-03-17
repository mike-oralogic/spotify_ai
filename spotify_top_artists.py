import json
import glob
import argparse
from collections import defaultdict

play_counts = defaultdict(int)
play_time = defaultdict(int)

for f in sorted(glob.glob(f"{args.data_dir}/*.json")):
    with open(f) as fh:
        data = json.load(fh)
    for entry in data:
        artist = entry.get("master_metadata_album_artist_name")
        if artist:
            play_counts[artist] += 1
            play_time[artist] += entry.get("ms_played", 0)

parser = argparse.ArgumentParser()
parser.add_argument("-n", type=int, default=10, help="Number of top artists to show (default: 10)")
parser.add_argument("-d", "--data-dir", default="/Users/mjprosser/Palantir/Data/Spotify/Spotify Extended Streaming History/Audio", help="Path to directory containing Spotify JSON files")
args = parser.parse_args()
TOP_N = args.n

print(f"\nTop {TOP_N} artists by play count:")
print(f"{'Rank':<6}{'Artist':<40}{'Plays':>10}")
print("-" * 56)
for i, (artist, plays) in enumerate(sorted(play_counts.items(), key=lambda x: x[1], reverse=True)[:TOP_N], 1):
    print(f"{i:<6}{artist:<40}{plays:>10,}")

print(f"\nTop {TOP_N} artists by listening time:")
print(f"{'Rank':<6}{'Artist':<40}{'Hours':>10}")
print("-" * 56)
for i, (artist, ms) in enumerate(sorted(play_time.items(), key=lambda x: x[1], reverse=True)[:TOP_N], 1):
    hours = ms / 3_600_000
    print(f"{i:<6}{artist:<40}{hours:>10.1f}")
