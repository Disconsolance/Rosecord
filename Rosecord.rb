require 'discordrb'
require 'uri'
require 'net/http'

Webhook='' # URL
Token='' # User token
TargetChannel=0 # Channel to spy on
Ignorelist=['@everyone', '@here'] # Do not send message on a webhook if contains a string from list
bot = Discordrb::Bot.new token: Token, type: :user 
uri = URI(Webhook)


bot.message do |event|
    if event.channel.id == TargetChannel
        if Ignorelist.any? { |word| event.message.content.include?(word)} == false
            name = event.message.author.username + "#" + event.message.author.discriminator
            avatarurl = String.new("https://cdn.discordapp.com/avatars/#{event.message.author.id}/#{event.message.author.avatar_id}.webp")
            message = "#{event.message.content}\n\n"
            if event.message.attachments.empty? == false
                message << "Attachment(s):\n"
                for attach in event.message.attachments
                    message << "#{attach.url}\n"
                end
            end
            message << "\nUserID: `#{event.message.author.id}`"
            post = Net::HTTP.post_form(uri, 'content' => message, 'username' => name, 'avatar_url' => avatarurl)
            puts post.body
        end
    end
end

bot.run