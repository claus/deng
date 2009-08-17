package deng.dom
{
	public class DOMException extends Error
	{
		public static const INDEX_SIZE_ERR:uint = 1;
		public static const DOMSTRING_SIZE_ERR:uint = 2;
		public static const HIERARCHY_REQUEST_ERR:uint = 3;
		public static const WRONG_DOCUMENT_ERR:uint = 4;
		public static const INVALID_CHARACTER_ERR:uint = 5;
		public static const NO_DATA_ALLOWED_ERR:uint = 6;
		public static const NO_MODIFICATION_ALLOWED_ERR:uint = 7;
		public static const NOT_FOUND_ERR:uint = 8;
		public static const NOT_SUPPORTED_ERR:uint = 9;
		public static const INUSE_ATTRIBUTE_ERR:uint = 10;

		// Introduced in DOM Level 2:
		public static const INVALID_STATE_ERR:uint = 11;
		public static const SYNTAX_ERR:uint = 12;
		public static const INVALID_MODIFICATION_ERR:uint = 13;
		public static const NAMESPACE_ERR:uint = 14;
		public static const INVALID_ACCESS_ERR:uint = 15;

		// Introduced in DOM Level 3:
		public static const VALIDATION_ERR:uint = 16;
		public static const TYPE_MISMATCH_ERR:uint = 17;

		public function DOMException(id:int = 0, message:String = "")
		{
			if(message == "") {
				switch(id) {
					case INDEX_SIZE_ERR: message = "The index or size is negative, or greater than the allowed value."; break;
					case DOMSTRING_SIZE_ERR: message = "The specified range of text does not fit into a DOMString."; break;
					case HIERARCHY_REQUEST_ERR: message = "An attempt was made to insert a node where it is not permitted."; break;
					case WRONG_DOCUMENT_ERR: message = "A node is used in a different document than the one that created it."; break;
					case INVALID_CHARACTER_ERR: message = "An invalid or illegal XML character is specified."; break;
					case NO_DATA_ALLOWED_ERR: message = "Data is specified for a node which does not support data."; break;
					case NO_MODIFICATION_ALLOWED_ERR: message = "An attempt is made to modify an object where modifications are not allowed."; break;
					case NOT_FOUND_ERR: message = "An attempt is made to reference a node in a context where it does not exist."; break;
					case NOT_SUPPORTED_ERR: message = "The implementation does not support the requested type of object or operation."; break;
					case INUSE_ATTRIBUTE_ERR: message = "An attempt is made to add an attribute that is already in use elsewhere."; break;
					case INVALID_STATE_ERR: message = "An attempt is made to use an object that is not, or is no longer, usable."; break;
					case SYNTAX_ERR: message = "An invalid or illegal string is specified."; break;
					case INVALID_MODIFICATION_ERR: message = "An attempt is made to modify the type of the underlying object."; break;
					case NAMESPACE_ERR: message = "An attempt is made to create or change an object in a way which is incorrect with regard to namespaces."; break;
					case INVALID_ACCESS_ERR: message = "A parameter or an operation is not supported by the underlying object."; break;
					case VALIDATION_ERR: message = "A call to a method such as insertBefore or removeChild would make the Node invalid with respect to document grammar."; break;
					case TYPE_MISMATCH_ERR: message = "The value type for this parameter name is incompatible with the expected value type."; break;
				}
			}
			super(message, id);
			name = "DOMException";
		}
		
	}
}