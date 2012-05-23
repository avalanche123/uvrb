module UV
  class Pipe
    include Stream

    def open(fileno)
      assert_type(Integer, fileno, "io#fileno must return an integer file descriptor")

      check_result! UV.pipe_open(handle, fileno)
    end

    def pending_instances=(count)
      assert_type(Integer, count, "count must be an Integer")

      UV.pipe_pending_instances(handle, count)
    end
  end
end