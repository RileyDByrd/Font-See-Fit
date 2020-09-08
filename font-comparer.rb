require 'google/apis/webfonts_v1'
require 'json'
require 'net/http'
require_relative '.bm3-core/win32/kernel/gdi_printer'
require 'tk'

class TkInterface
  attr_accessor :menubtn4_text
  attr_accessor :menubtn4_index
  attr_accessor :label2_font
  attr_accessor :label3_font
  attr_accessor :radbtn41_bool
  attr_accessor :radbtn42_bool
  def initialize
    this = self
    @root = TkRoot.new do
      title "Font See Fit"
      background '#222'
      minsize(700, 500)
      maxsize(700, 500)
    end

    @frame1 = TkFrame.new(@root) do
      background '#344'
      width 300
      height 150
      pack(pady: 25, side: 'bottom')
    end
    
    var1 = TkVariable.new
    
    btn1_counter = 0
    btn1_clicked = proc do
      case btn1_counter
      when 0
        var1.value = 'The quick brown fox jumps.'
      when 1
        var1.value = 'Lorem ipsum dolor sit amet.'
      when 2
        var1.value = 'Now is the time for all good men to come.'
      end
      
      btn1_counter = (btn1_counter + 1) % 3
    end
    
    @btn1 = TkButton.new(@frame1) do
      font TkFont.new('verdana 18 bold')
      text 'Text to Compare'
      command btn1_clicked
      background '#233'
      activebackground '#233'
      foreground '#abb'
      activeforeground '#abb'
      borderwidth 0
      place(x: 27, y: 15)
    end
    
    @entry1 = TkEntry.new(@frame1) do
      font TkFont.new('verdana 18')
      foreground '#fff'
      background '#455'
      justify 'center'
      textvariable var1
      place(height: 45, width: 285, x: 7, y: 90)
    end

    @frame2 = TkFrame.new(@root) do
      background '#344'
      width 290
      height 85
      pack(side: 'left')
      place(x: 15, y: 185)
    end
    
    
    @label2_font = TkFont.new('verdana 18')
    @label2 = TkLabel.new(@frame2) do
      font this.label2_font
      borderwidth 1
      justify 'center'
      textvariable var1
      background '#233'
      foreground '#abb'
      wraplength 270
      place(width: 270, height: 68, x: 10, y: 9)
    end

    @frame3 = TkFrame.new(@root) do
      background '#344'
      width 290
      height 85
      pack(side: 'right')
      place(x: 395, y: 185)
    end

    @label3_font = TkFont.new('verdana 18')
    @label3 = TkLabel.new(@frame3) do
      font this.label3_font
      borderwidth 1
      justify 'center'
      textvariable var1
      background '#233'
      foreground '#abb'
      wraplength 270
      place(width: 270, height: 68, x: 10, y: 9)
    end

    @frame4 = TkFrame.new(@root) do
      background '#344'
      width 290
      height 115
      pack(pady: 22, side: 'top')
    end
    
    @menubtn4_text = TkVariable.new('Select a Font')
    @menubtn4_index = 0
    @menubtn4 = TkMenubutton.new(@frame4) do
      font TkFont.new('verdana 18 bold')
      textvariable this.menubtn4_text
      background '#233'
      activebackground '#233'
      foreground '#abb'
      activeforeground '#abb'
      justify 'center'
      place(width: 260, height: 45, x: 14, y: 15)
    end
    @menubtn4_menu = TkMenu.new(@menubtn4)
    @menubtn4.menu = @menubtn4_menu

    fetch_font_list
    build_font_menu
    
    @radbtn41_bool = TkVariable.new(false)
    radbtn41_proc = proc do
      download_font
      add_font_to_sess
      apply_font(this.label2_font)
    end
    
    radbtn41 = TkRadioButton.new(@frame4) do
      font TkFont.new('verdana 10')
      text 'Left'
      variable this.radbtn41_bool
      background '#233'
      activebackground '#233'
      foreground '#abb'
      activeforeground '#abb'
      command radbtn41_proc
      place(x: 40, y: 75)
    end

    @radbtn42_bool = TkVariable.new(false)
    radbtn42_proc = proc do
      download_font
      add_font_to_sess
      apply_font(this.label3_font)
    end
    
    radbtn42 = TkRadioButton.new(@frame4) do
      font TkFont.new('verdana 10')
      text 'Right'
      variable this.radbtn42_bool
      background '#233'
      activebackground '#233'
      foreground '#abb'
      activeforeground '#abb'
      command radbtn42_proc
      place(x: 188, y: 75)
    end

    @frame5 = TkFrame.new(@root) do
      background '#344'
      pack(pady: 22, side: 'top')
      place(width: 90, height: 60, x: 54, y: 48)
    end
    
    btn5 = TkButton.new(@frame5) do
      pack(fill: 'both', expand: true)
      font TkFont.new('verdana 12 bold')
      wraplength 50
      text 'Clear Fonts'
      background '#233'
      activebackground '#233'
      foreground '#abb'
      activeforeground '#abb'
      borderwidth 0
      command (proc{ this.clear_fonts })
    end
  # Button to open in word for typing
  # Button for download
  # Search for fonts
  end

  def fetch_font_list
    webfonts = Google::Apis::WebfontsV1::WebfontsService.new
    webfonts.key = File.open('api_key').read

    if (not FileTest.exist?('google_webfonts.json')) || File.mtime('.google_webfonts.json').strftime('%m/%d/%Y') != Time.now.strftime('%m/%d/%Y')
      file = File.open('.google_webfonts.json', 'w')
      file.puts webfonts.list_webfonts(sort: 'trending', fields: 'items(family,files)').to_json
      file.close
      puts 'I wrote to .google_webfonts.json'
    end
    
    file = File.open('.google_webfonts.json', 'r')
    @font_arr = JSON.parse(file.read)['items']
    file.close
  end

  def build_font_menu
    this = self
    @font_arr.each_with_index do |f, i|
      @menubtn4_menu.add(
        'command',
        label: "#{i+1}. #{f['family']}",
        command: proc do
          this.menubtn4_text.value = f['family']
          this.menubtn4_index = i
          this.radbtn41_bool.value = false
          this.radbtn42_bool.value = false
        end
      )
      break if i >= 30 - 1
    end
  end

  def download_font
    ffile = @font_arr[@menubtn4_index]['files']['regular']
    @filename = ''
    ffile.reverse.each_char.with_index do |c, i|
      if c == '/'
        @filename = ".temp_fonts/#{ffile[ffile.length-i..-1]}"
        break
      end
    end

    unless File.directory?('.temp_fonts/')
      FileUtils.mkdir_p('.temp_fonts/')
    end
    
    already_downloaded = File.file? @filename
    
    unless already_downloaded
      puts "Downloading #{@filename}"
      file = File.open(@filename, 'wb')
      uri = URI(ffile)
      begin
        Net::HTTP.new(uri.host, uri.port).request_get(uri) do |resp|
          resp.read_body do |segment|
            file.write(segment)
          end
        end
      ensure
        file.close
      end
    end
    
    already_downloaded
  end
  
  def add_font_to_sess
    if @gdi_intf.nil?
      @gdi_intf = BM3::Win32::GDI::Printer.new
    end
    gdi_fam1 = @gdi_intf.font_families
    @gdi_intf.load_font(File.expand_path(@filename))
    @gdi_intf.font_families.each do |f|
      unless gdi_fam1.include? f
        puts "#{f} was successfully loaded."
      end
    end
  end
  
  def apply_font(font_obj)
    font_obj.family = @menubtn4_text.value
    font_obj.size = (68 * 0.21).floor
  end

  def clear_fonts
    if @gdi_intf.nil?
      @gdi_intf = BM3::Win32::GDI::Printer.new
    end
    Dir.entries('.temp_fonts/')[2..-1].each do |ff|
      begin
        @gdi_intf.unload_font(File.expand_path(".temp_fonts/#{ff}"))
      rescue ArgumentError
        puts 'Font already unloaded or not loaded to begin with.'
      end
    
      begin
        File.delete(".temp_fonts/#{ff}")
      rescue
        puts 'Could not delete file. This usually means an application was opened that\'s using the font. A system reboot
 or even a logout can fix this.'
      end
    end

  end
end

TkInterface.new
Tk.mainloop
