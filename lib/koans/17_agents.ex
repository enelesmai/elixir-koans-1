defmodule Agents do
  use Koans

  @intro "Agents"

  koan "Agents maintain state, so you can ask them about it" do
    {:ok, pid} = Agent.start_link(fn -> "Hi there" end)
    assert Agent.get(pid, & &1) == "Hi there"
  end

  koan "Agents may also be named so that you don't have to keep the pid around" do
    Agent.start_link(fn -> "Why hello" end, name: AgentSmith)
    assert Agent.get(AgentSmith, & &1) == "Why hello"
  end

  koan "Update to update the state" do
    Agent.start_link(fn -> "Hi there" end, name: :greeter)

    Agent.update(:greeter, fn old ->
      String.upcase(old)
    end)

    assert Agent.get(:greeter, & &1) == "HI THERE"
  end

  koan "Use get_and_update when you need to read and change a value in one go" do
    Agent.start_link(fn -> ["Milk", "Cookie"] end, name: :groceries)

    old_list =
      Agent.get_and_update(:groceries, fn old ->
        {old, ["Bread" | old]}
      end)

    assert old_list == ["Milk", "Cookie"]
    assert Agent.get(:groceries, & &1) == ["Bread", "Milk", "Cookie"]
    assert Agent.get(:groceries, fn state -> state end) == ["Bread", "Milk", "Cookie"]
  end

  koan "Somebody has to switch off the light at the end of the day" do
    {:ok, pid} = Agent.start_link(fn -> "Fin." end, name: :stoppable)

    Agent.stop(:stoppable)

    assert Process.alive?(pid) == false
  end
end
