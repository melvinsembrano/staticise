module Guard
  class Staticise
    class Notifier
      class << self
        def image(result)
          result ? :success: :faild
        end

        def notify(result, message)
          ::Guard::Notifier.notify(message, :title => 'Guard::Staticise', :image => image(result))
        end
      end
    end
  end
end
