package org.w3c.css.dom
{

	/**
	 * The MediaList interface provides the abstraction of an ordered collection of media, without defining or constraining how this collection is implemented. An empty list is the same as a list that contains the medium "all".
	 * The items in the MediaList are accessible via an integral index, starting from 0.
	 */
	public interface IMediaList
	{

		/**
		 * The parsable textual representation of the media list. This is a comma-separated list of media.
		 */
		function get mediaText():String;

		/**
		 * @throws IDOMException
		 * SYNTAX_ERR: Raised if the specified string value has a syntax error and is unparsable.
		 * NO_MODIFICATION_ALLOWED_ERR: Raised if this media list is readonly.
		 */
		function set mediaText(value:String):void;

		/**
		 * The number of media in the list. The range of valid media is 0 to length-1 inclusive.
		 */
		function get length():uint;

		/**
		 * Returns the indexth in the list. If index is greater than or equal to the number of media in the list, this returns null.
		 * @param index Index into the collection.
		 * @return The medium at the indexth position in the MediaList, or null if that is not a valid index.
		 */
		function item(index:uint):String;

		/**
		 * Deletes the medium indicated by oldMedium from the list.
		 * @param oldMedium The medium to delete in the media list.
		 * @throws IDOMException
		 * NO_MODIFICATION_ALLOWED_ERR: Raised if this list is readonly.
		 * NOT_FOUND_ERR: Raised if oldMedium is not in the list.
		 */
		function deleteMedium(oldMedium:String):void;

		/**
		 * Adds the medium newMedium to the end of the list. If the newMedium is already used, it is first removed.
		 * @param newMedium The new medium to add.
		 * @throws IDOMException
		 * INVALID_CHARACTER_ERR: If the medium contains characters that are invalid in the underlying style language.
		 * NO_MODIFICATION_ALLOWED_ERR: Raised if this list is readonly.
		 */
		function appendMedium(newMedium:String):void;

	}

}