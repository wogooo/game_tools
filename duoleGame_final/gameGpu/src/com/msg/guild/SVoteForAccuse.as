package com.msg.guild {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.guild.SQueryVote;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SVoteForAccuse extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ERROR_INFO:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.guild.SVoteForAccuse.error_info", "errorInfo", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var errorInfo:int;

		/**
		 *  @private
		 */
		public static const VOTE_RES:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.guild.SVoteForAccuse.vote_res", "voteRes", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.guild.SQueryVote; });

		private var vote_res$field:com.msg.guild.SQueryVote;

		public function clearVoteRes():void {
			vote_res$field = null;
		}

		public function get hasVoteRes():Boolean {
			return vote_res$field != null;
		}

		public function set voteRes(value:com.msg.guild.SQueryVote):void {
			vote_res$field = value;
		}

		public function get voteRes():com.msg.guild.SQueryVote {
			return vote_res$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.errorInfo);
			if (hasVoteRes) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, vote_res$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var error_info$count:uint = 0;
			var vote_res$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (error_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: SVoteForAccuse.errorInfo cannot be set twice.');
					}
					++error_info$count;
					this.errorInfo = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (vote_res$count != 0) {
						throw new flash.errors.IOError('Bad data format: SVoteForAccuse.voteRes cannot be set twice.');
					}
					++vote_res$count;
					this.voteRes = new com.msg.guild.SQueryVote();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.voteRes);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
