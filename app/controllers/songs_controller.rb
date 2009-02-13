class SongsController < ApplicationController
  # GET /songs
  # GET /songs.xml
  def index
    @songs = Song.view(database_name, "songs/all")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @songs }
    end
  end

  # GET /songs/1
  # GET /songs/1.xml
  def show
    @song = Song.find(database_name, params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @song }
    end
  end

  # GET /songs/new
  # GET /songs/new.xml
  def new
    @song = Song.new(database_name)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @song }
    end
  end

  # GET /songs/1/edit
  def edit
    @song = Song.find(database_name, params[:id])
  end

  # GET /songs/1/file
  def file
    @song = Song.find(database_name, params[:id])
    # Attachment
    metadata = @song._attachments[@song.filename]
    data = Song.db(database_name).fetch_attachment(@song.id, @song.filename)
    send_data(data, {
      :filename    => @song.filename,
      :type        => metadata['content_type'],
      :disposition => "inline",
    })
    return
  end

  # POST /songs
  # POST /songs.xml
  def create
    @song = Song.new(database_name)
    params[:song][:filename] = params[:song][:attachment].original_filename

    respond_to do |format|
      if @song.save(params[:song])
        flash[:notice] = 'Song was successfully created.'
        format.html { redirect_to(@song) }
        format.xml  { render :xml => @song, :status => :created, :location => @song }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @song.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /songs/1
  # PUT /songs/1.xml
  def update
    @song = Song.find(database_name, params[:id])

    params[:song][:filename] = params[:song][:attachment].original_filename if params[:song][:attachment] != ""

    logger.debug "going to save"

    respond_to do |format|
      if @song.save(params[:song])
        flash[:notice] = 'Song was successfully updated.'
        format.html { redirect_to(@song) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @song.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.xml
  def destroy
    @song = Song.find(database_name, params[:id])
    @song.destroy

    respond_to do |format|
      format.html { redirect_to(songs_url) }
      format.xml  { head :ok }
    end
  end
end
