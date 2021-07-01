defmodule Task.Completed do
  @moduledoc """
  Tasks are processes meant to execute one particular action throughout their lifetime,
  often with little or no communication with other processes. In some cases, it is useful
  to create a "completed" task that represents a task that has already run and generated
  a result. For example, when processing data you may be able to determine that certain
  inputs are invalid before dispatching them for further processing:

      def process(data) do
        tasks =
          for entry <- data do
            if invalid_input?(entry) do
              Task.completed({:error, :invalid_input})
            else
              Task.async(fn -> further_process(entry) end)
            end
          end

        Task.await_many(tasks)
      end

  In many cases, `Task.completed/1` may be avoided in favor of returning the result directly.
  You should generally only require this variant when working with mixed asynchrony, when
  a group of inputs will be handled partially synchronously and partially asynchronously.
  """

  @doc """
  A variant of the Task struct that represents a task with a known result.

  It contains these fields:

    * `:result` - the task's result

    * `:ref` - a unique reference

    * `:owner` - the PID of the process that created the task

  """
  @enforce_keys [:result, :ref, :owner]
  defstruct result: nil, ref: nil, owner: nil

  @typedoc """
  A variant of the Task type that represents a task with a known result.

  See `%Task.Completed{}` for information about each field of the structure.
  """
  @type t :: %__MODULE__{
          result: any(),
          ref: reference(),
          owner: pid()
        }
end
