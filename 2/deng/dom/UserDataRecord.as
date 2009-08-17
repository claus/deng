package deng.dom
{
	import org.w3c.dom.*;
	
	public class UserDataRecord
	{
		protected var _data:Object;
		protected var _handler:UserDataHandler;
		
		public function UserDataRecord(data:Object, handler:UserDataHandler)
		{
			_data = data;
			_handler = handler;
		}
		
		public function get data():Object {
			return _data;
		}
		
		public function get handler():UserDataHandler {
			return _handler;
		}
	}
}