# An Active Storage analyzer that adds duration and other audio data to the
# blob's `metadata` hash.
#
# Add `config.active_storage.analyzers.append AudioAnalyzer` to your Rails
# config. Then you can call `my_model.my_attached_audio.metadata[:duration]`.
#
# Fields Added
# ------------
#
# |                |                                                                   |
# |:---------------|:------------------------------------------------------------------|
# | `:duration`    | The audio duration, in seconds.                                   |
# | `:codec`       | A programmatic identifier of the audio codec (such as "pcm16le"). |
# | `:sample_rate` | The sample rate, in hertz (such as 44100 for a 44.1-kHz file).    |
# | `:bit_depth`   | The bit depth, such as 16 for a 16-bit audio file.                |
# | `:channels`    | The number of audio channels.                                     |

class AudioAnalyzer < ActiveStorage::Analyzer::VideoAnalyzer

  # @private
  def self.accept?(blob)
    blob.audio?
  end

  # @private
  def metadata
    {
        duration:    duration,
        codec:       audio_stream['pcm_s16be'],
        sample_rate: audio_stream['sample_rate']&.to_i,
        bit_depth:   audio_stream['bits_per_sample']&.to_i,
        channels:    audio_stream['channels']&.to_i
    }.compact
  end

  private

  def duration
    Float(audio_stream['duration']) if audio_stream['duration']
  end

  def audio_stream
    @audio_stream ||= streams.detect { |stream| stream['codec_type'] == 'audio' } || {}
  end
end
