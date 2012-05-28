require 'spec_helper'

describe UV::File do
  let(:loop) { double() }
  let(:loop_pointer) { double() }
  let(:fd) { rand(6555) }
  subject { UV::File.new(loop, fd) }

  before(:each) do
    loop.stub(:to_ptr) { loop_pointer }
  end

  describe "#close" do
    let(:close_request) { double() }

    it "requires a block" do
      expect { subject.close }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_close" do
      UV.should_receive(:create_request).with(:uv_fs).and_return(close_request)
      UV.should_receive(:fs_close).with(loop_pointer, close_request, fd, subject.method(:on_close))

      subject.close { |e| }
    end
  end

  describe "#read" do
    let(:read_request) { double() }
    let(:length) { 1024 }
    let(:read_buffer) { double() }
    let(:offset) { 0 }

    it "requires a block" do
      expect { subject.read(length, offset) }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_read" do
      FFI::MemoryPointer.should_receive(:new).with(length).and_return(read_buffer)
      UV.should_receive(:create_request).with(:uv_fs).and_return(read_request)
      UV.should_receive(:fs_read).with(loop_pointer, read_request, fd, read_buffer, length, offset, subject.method(:on_read))

      subject.read(length, offset) { |e, data| }
    end
  end

  describe "#write" do
    let(:offset) { 0 }
    let(:data) { "some payload" }
    let(:write_buffer_length) { data.size }
    let(:write_buffer) { double() }
    let(:write_request) { double() }

    it "requires a block" do
      expect { subject.write(data, offset) }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_write" do
      FFI::MemoryPointer.should_receive(:from_string).with(data).and_return(write_buffer)
      UV.should_receive(:create_request).with(:uv_fs).and_return(write_request)
      UV.should_receive(:fs_write).with(loop_pointer, write_request, fd, write_buffer, write_buffer_length, offset, subject.method(:on_write))

      subject.write(data, offset) { |e| }
    end
  end

  describe "#stat" do
    let(:stat_request) { double() }

    it "requires a block" do
      expect { subject.stat }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_fstat" do
      UV.should_receive(:create_request).with(:uv_fs).and_return(stat_request)
      UV.should_receive(:fs_fstat).with(loop_pointer, stat_request, fd, subject.method(:on_stat))

      subject.stat { |e, stat| }
    end
  end

  describe "#sync" do
    let(:sync_request) { double() }

    it "requires a block" do
      expect { subject.sync }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_fsync" do
      UV.should_receive(:create_request).with(:uv_fs).and_return(sync_request)
      UV.should_receive(:fs_fsync).with(loop_pointer, sync_request, fd, subject.method(:on_sync))

      subject.sync { |e| }
    end
  end

  describe "#datasync" do
    let(:datasync_request) { double() }

    it "requires a block" do
      expect { subject.datasync }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_fdatasync" do
      UV.should_receive(:create_request).with(:uv_fs).and_return(datasync_request)
      UV.should_receive(:fs_fdatasync).with(loop_pointer, datasync_request, fd, subject.method(:on_datasync))

      subject.datasync { |e| }
    end
  end

  describe "#truncate" do
    let(:offset) { 0 }
    let(:truncate_request) { double() }

    it "requires a block" do
      expect { subject.truncate(offset) }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_ftruncate" do
      UV.should_receive(:create_request).with(:uv_fs).and_return(truncate_request)
      UV.should_receive(:fs_ftruncate).with(loop_pointer, truncate_request, fd, offset, subject.method(:on_truncate))

      subject.truncate(offset) { |e| }
    end
  end

  describe "#utime" do
    let(:atime) { 1291404900 } # 2010-12-03 20:35:00
    let(:mtime) { 400497753 }  # 1982-09-10 11:22:33
    let(:utime_request) { double() }

    it "requires a block" do
      expect { subject.utime(atime, mtime) }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_futime" do
      UV.should_receive(:create_request).with(:uv_fs).and_return(utime_request)
      UV.should_receive(:fs_futime).with(loop_pointer, utime_request, fd, atime, mtime, subject.method(:on_utime))

      subject.utime(atime, mtime) { |e| }
    end
  end

  describe "#chmod" do
    let(:mode) { 0755 }
    let(:chmod_request) { double() }

    it "requires a block" do
      expect { subject.chmod(mode) }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_fchmod" do
      UV.should_receive(:create_request).with(:uv_fs).and_return(chmod_request)
      UV.should_receive(:fs_fchmod).with(loop_pointer, chmod_request, fd, mode, subject.method(:on_chmod))

      subject.chmod(mode) { |e| }
    end
  end

  describe "#chown" do
    let(:uid) { 0 }
    let(:gid) { 0 }
    let(:chown_request) { double() }

    it "requires a block" do
      expect { subject.chown(uid, gid) }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_fchown" do
      UV.should_receive(:create_request).with(:uv_fs).and_return(chown_request)
      UV.should_receive(:fs_fchown).with(loop_pointer, chown_request, fd, uid, gid, subject.method(:on_chown))

      subject.chown(uid, gid) { |e| }
    end
  end
end