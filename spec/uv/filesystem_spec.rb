require 'spec_helper'

describe UV::Filesystem do
  let(:loop) { double() }
  let(:loop_pointer) { double() }
  subject { UV::Filesystem.new(loop) }

  before(:each) do
    loop.stub(:to_ptr) { loop_pointer }
  end

  describe "#open" do
    let(:path) { "/tmp/file" }
    let(:mode) { 0755 }
    let(:flags) { File::CREAT | File::EXCL | File::APPEND }
    let(:open_request) { double() }

    it "requires a block" do
      expect { subject.open(path, flags, mode) }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_open" do
      UV.should_receive(:allocate_request_fs).and_return(open_request)
      UV.should_receive(:fs_open).with(loop_pointer, open_request, path, flags, mode, subject.method(:on_open))

      subject.open(path, flags, mode) { |e, file| }
    end
  end

  describe "#unlink" do
    let(:path) { "/tmp/file" }
    let(:unlink_request) { double() }

    it "requires a block" do
      expect { subject.unlink(path) }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_unlink" do
      UV.should_receive(:allocate_request_fs).and_return(unlink_request)
      UV.should_receive(:fs_unlink).with(loop_pointer, unlink_request, path, subject.method(:on_unlink))

      subject.unlink(path) { |e| }
    end
  end

  describe "#mkdir" do
    let(:path) { "/tmp/dir" }
    let(:mode) { 0777 }
    let(:mkdir_request) { double() }

    it "requires a block" do
      expect { subject.mkdir(path) }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_mkdir" do
      UV.should_receive(:allocate_request_fs).and_return(mkdir_request)
      UV.should_receive(:fs_mkdir).with(loop_pointer, mkdir_request, path, mode, subject.method(:on_mkdir))

      subject.mkdir(path, mode) { |e| }
    end
  end

  describe "#rmdir" do
    let(:path) { "/tmp/dir" }
    let(:rmdir_request) { double() }

    it "requires a block" do
      expect { subject.rmdir(path) }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_rmdir" do
      UV.should_receive(:allocate_request_fs).and_return(rmdir_request)
      UV.should_receive(:fs_rmdir).with(loop_pointer, rmdir_request, path, subject.method(:on_rmdir))

      subject.rmdir(path) { |e| }
    end
  end

  describe "#readdir" do
    let(:path) { '/tmp' }
    let(:readdir_request) { double() }

    it "requires a block" do
      expect { subject.readdir(path) }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_readdir" do
      UV.should_receive(:allocate_request_fs).and_return(readdir_request)
      UV.should_receive(:fs_readdir).with(loop_pointer, readdir_request, path, 0, subject.method(:on_readdir))

      subject.readdir(path) { |e, files| }
    end
  end

  describe "#stat" do
    let(:path) { '/tmp/filename' }
    let(:stat_request) { double() }

    it "requires a block" do
      expect { subject.stat(path) }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_stat" do
      UV.should_receive(:allocate_request_fs).and_return(stat_request)
      UV.should_receive(:fs_stat).with(loop_pointer, stat_request, path, subject.method(:on_stat))

      subject.stat(path) { |e, stat| }
    end
  end

  describe "#rename" do
    let(:old_path) { '/tmp/old_file' }
    let(:new_path) { '/tmp/new_file' }
    let(:rename_request) { double() }

    it "requires a block" do
      expect { subject.rename(old_path, new_path) }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_rename" do
      UV.should_receive(:allocate_request_fs).and_return(rename_request)
      UV.should_receive(:fs_rename).with(loop_pointer, rename_request, old_path, new_path, subject.method(:on_rename))

      subject.rename(old_path, new_path) { |e| }
    end
  end

  describe "#chmod" do
    let(:path) { '/tmp/somepath' }
    let(:mode) { 0755 }
    let(:chmod_request) { double() }

    it "requires a block" do
      expect { subject.chmod(path, mode) }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_chmod" do
      UV.should_receive(:allocate_request_fs).and_return(chmod_request)
      UV.should_receive(:fs_chmod).with(loop_pointer, chmod_request, path, mode, subject.method(:on_chmod))

      subject.chmod(path, mode) { |e| }
    end
  end

  describe "#utime" do
    let(:path) { '/tmp/filename' }
    let(:atime) { 1291404900 } # 2010-12-03 20:35:00
    let(:mtime) { 400497753 }  # 1982-09-10 11:22:33
    let(:utime_request) { double() }

    it "requires a block" do
      expect { subject.utime(path, atime, mtime) }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_utime" do
      UV.should_receive(:allocate_request_fs).and_return(utime_request)
      UV.should_receive(:fs_utime).with(loop_pointer, utime_request, path, atime, mtime, subject.method(:on_utime))

      subject.utime(path, atime, mtime) { |e| }
    end
  end

  describe "#lstat" do
    let(:path) { '/tmp/filename' }
    let(:lstat_request) { double() }

    it "requires a block" do
      expect { subject.lstat(path) }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_lstat" do
      UV.should_receive(:allocate_request_fs).and_return(lstat_request)
      UV.should_receive(:fs_lstat).with(loop_pointer, lstat_request, path, subject.method(:on_lstat))

      subject.lstat(path) { |e, stat| }
    end
  end

  describe "#link" do
    let(:old_path) { '/tmp/old_file' }
    let(:new_path) { '/tmp/new_file' }
    let(:link_request) { double() }

    it "requires a block" do
      expect { subject.link(old_path, new_path) }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_link" do
      UV.should_receive(:allocate_request_fs).and_return(link_request)
      UV.should_receive(:fs_link).with(loop_pointer, link_request, old_path, new_path, subject.method(:on_link))

      subject.link(old_path, new_path) { |e| }
    end
  end

  describe "#symlink" do
    let(:old_path) { '/tmp/old_file' }
    let(:new_path) { '/tmp/new_file' }
    let(:symlink_request) { double() }

    it "requires a block" do
      expect { subject.symlink(old_path, new_path) }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_link" do
      UV.should_receive(:allocate_request_fs).and_return(symlink_request)
      UV.should_receive(:fs_symlink).with(loop_pointer, symlink_request, old_path, new_path, 0, subject.method(:on_symlink))

      subject.symlink(old_path, new_path) { |e| }
    end
  end

  describe "#readlink" do
    let(:path) { '/tmp/symlink' }
    let(:readlink_request) { double() }

    it "requires a block" do
      expect { subject.readlink(path) }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_readlink" do
      UV.should_receive(:allocate_request_fs).and_return(readlink_request)
      UV.should_receive(:fs_readlink).with(loop_pointer, readlink_request, path, subject.method(:on_readlink))

      subject.readlink(path) { |e, path| }
    end
  end

  describe "#chown" do
    let(:path) { '/tmp/chownable_file' }
    let(:uid) { 0 }
    let(:gid) { 0 }
    let(:chown_request) { double() }

    it "requires a block" do
      expect { subject.chown(path, uid, gid) }.to raise_error(ArgumentError)
    end

    it "calls UV.fs_chown" do
      UV.should_receive(:allocate_request_fs).and_return(chown_request)
      UV.should_receive(:fs_chown).with(loop_pointer, chown_request, path, uid, gid, subject.method(:on_chown))

      subject.chown(path, uid, gid) { |e| }
    end
  end
end