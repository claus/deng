package org.w3c.dom
{
	public interface IUserDataHandler
	{
		function handle(operation:int, key:String, data:Object, src:INode, dst:INode):void;

		// OperationType:
		// --------------------
		// NODE_CLONED    = 1;
		// NODE_IMPORTED  = 2;
		// NODE_DELETED   = 3;
		// NODE_RENAMED   = 4;
	}
}
