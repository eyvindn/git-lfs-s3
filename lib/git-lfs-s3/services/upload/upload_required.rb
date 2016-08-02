module GitLfsS3
  module UploadService
    class UploadRequired < Base
      def self.should_handle?(req, object)
        !object.exists? || object.size != req['size']
      end

      def response
        {
          '_links' => {
            'upload' => {
              'href' => upload_destination,
              'header' => upload_headers
            },
            'verify' => {
              'href' => File.join(server_url, 'verify')
            }
          }
        }
      end

      def status
        202
      end

      private

      def upload_destination
        "https://:@" + object.presigned_url(:put)[8..-1]
      end

      def upload_headers
        {'content-type' => ''}
      end
    end
  end
end
