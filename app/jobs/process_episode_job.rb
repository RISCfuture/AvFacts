# This job calls {Episode#preprocess!} on the given episode.

class ProcessEpisodeJob < ApplicationJob
  queue_as :default

  # Pre-processes an episode's audio and image files.
  #
  # @param [Episode] episode An episode to preprocess.

  def perform(episode)
    episode.preprocess!
  end
end
