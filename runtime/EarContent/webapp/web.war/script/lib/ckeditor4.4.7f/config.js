/**
 * @license Copyright (c) 2003-2015, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	config.language = 'ko';
	config.uiColor = '#F0F7FF'; //config.uiColor = '#AADC6E';

    config.font_names = '맑은 고딕; 돋움; 바탕; 궁서; ' + CKEDITOR.config.font_names;

    config.toolbar =[
        ['Source','-','Cut','Copy','Paste','PasteText','PasteFromWord','Undo','Redo','SelectAll','RemoveFormat'],
        '/',
        ['Bold','Italic','Underline','Strike', 'Subscript','Superscript'],
        ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
        ['NumberedList','BulletedList','Outdent','Indent','Blockquote'], //,'CreateDiv'
        ['Image','Table','HorizontalRule','Smiley','SpecialChar'], //,'PageBreak'
        ['Styles','Format','Font','FontSize','TextColor','BGColor','Maximize'] //, 'ShowBlocks'
    ];
};
