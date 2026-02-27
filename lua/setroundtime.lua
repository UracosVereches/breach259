timer.Adjust("RoundTime", timer.TimeLeft("RoundTime") - 105, nil, nil)

net.Start("UpdateTime")
	net.WriteString(tostring(timer.TimeLeft( "RoundTime" )))
net.Broadcast()