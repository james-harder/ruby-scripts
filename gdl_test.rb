require 'glimmer-dsl-libui'

include Glimmer

window('hello button', 300, 200) {
    button('Button') {
        on_clicked do
            # msg_box('Information', 'You clicked it.')
            window_two()
        end
    }
}.show

def window_two
    puts 'hello'
    window('hello world').show
end