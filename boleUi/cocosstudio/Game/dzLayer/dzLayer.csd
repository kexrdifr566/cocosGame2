<GameFile>
  <PropertyGroup Name="dzLayer" Type="Layer" ID="f72359ad-d92b-4e9f-a130-86737bbb27c2" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="6" ctype="GameLayerObjectData">
        <Size X="1280.0000" Y="720.0000" />
        <Children>
          <AbstractNodeData Name="P" ActionTag="-150870042" Tag="517" IconVisible="False" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="1280.0000" Y="720.0000" />
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="1.0000" Y="1.0000" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="bj" ActionTag="626168731" Tag="7" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" TouchEnable="True" ClipAble="False" BackColorAlpha="0" ColorAngle="90.0000" LeftEage="422" RightEage="422" TopEage="237" BottomEage="237" Scale9OriginX="422" Scale9OriginY="237" Scale9Width="436" Scale9Height="246" ctype="PanelObjectData">
            <Size X="1280.0000" Y="720.0000" />
            <Children>
              <AbstractNodeData Name="game_name" ActionTag="-263928482" Tag="285" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="560.5000" RightMargin="560.5000" TopMargin="190.9301" BottomMargin="491.0699" ctype="SpriteObjectData">
                <Size X="159.0000" Y="38.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="640.0000" Y="510.0699" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.7084" />
                <PreSize X="0.1242" Y="0.0528" />
                <FileData Type="PlistSubImage" Path="game_1.png" Plist="Game/Public.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="wait" ActionTag="-1762226911" Tag="577" IconVisible="False" LeftMargin="881.9997" RightMargin="228.0002" TopMargin="603.0000" BottomMargin="67.0000" LeftEage="77" RightEage="77" TopEage="27" BottomEage="27" Scale9OriginX="77" Scale9OriginY="23" Scale9Width="16" Scale9Height="4" ctype="ImageViewObjectData">
                <Size X="170.0000" Y="50.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="966.9997" Y="92.0000" />
                <Scale ScaleX="0.9000" ScaleY="0.9000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.7555" Y="0.1278" />
                <PreSize X="0.1328" Y="0.0694" />
                <FileData Type="PlistSubImage" Path="img_pg.png" Plist="Game/Public.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="down" ActionTag="-1773199027" Tag="2033" IconVisible="True" RightMargin="1280.0000" TopMargin="720.0000" ctype="SingleNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <Children>
                  <AbstractNodeData Name="B_1" ActionTag="1502977047" Tag="27" IconVisible="False" LeftMargin="866.5817" RightMargin="-958.5817" TopMargin="-146.4742" BottomMargin="45.4742" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="62" Scale9Height="79" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="92.0000" Y="101.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_237" ActionTag="475573384" Tag="3370" IconVisible="False" LeftMargin="7.4655" RightMargin="4.5345" TopMargin="92.3626" BottomMargin="-21.3626" LeftEage="26" RightEage="26" TopEage="9" BottomEage="9" Scale9OriginX="26" Scale9OriginY="9" Scale9Width="28" Scale9Height="12" ctype="ImageViewObjectData">
                        <Size X="80.0000" Y="30.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="47.4655" Y="-6.3626" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5159" Y="-0.0630" />
                        <PreSize X="0.8696" Y="0.2970" />
                        <FileData Type="PlistSubImage" Path="sh.png" Plist="Game/Dz.plist" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="912.5817" Y="95.9742" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                    <PressedFileData Type="PlistSubImage" Path="s.png" Plist="Game/Dz.plist" />
                    <NormalFileData Type="PlistSubImage" Path="s.png" Plist="Game/Dz.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="B_3" ActionTag="-625733641" Tag="29" IconVisible="False" LeftMargin="1072.8114" RightMargin="-1164.8114" TopMargin="-146.4742" BottomMargin="45.4742" TouchEnable="True" FontSize="36" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="62" Scale9Height="79" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="92.0000" Y="101.0000" />
                    <Children>
                      <AbstractNodeData Name="T" ActionTag="-797598812" Tag="3367" IconVisible="False" LeftMargin="13.5955" RightMargin="13.4045" TopMargin="29.3196" BottomMargin="30.6804" FontSize="36" LabelText="200" ShadowOffsetX="1.0000" ShadowOffsetY="-1.0000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="65.0000" Y="41.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="46.0955" Y="51.1804" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5010" Y="0.5067" />
                        <PreSize X="0.7065" Y="0.4059" />
                        <FontResource Type="Normal" Path="font/FZY4JW.TTF" Plist="" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="26" G="26" B="26" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_235" ActionTag="1863936846" Tag="3368" IconVisible="False" LeftMargin="6.0955" RightMargin="5.9045" TopMargin="91.3870" BottomMargin="-20.3870" LeftEage="26" RightEage="26" TopEage="9" BottomEage="9" Scale9OriginX="26" Scale9OriginY="9" Scale9Width="28" Scale9Height="12" ctype="ImageViewObjectData">
                        <Size X="80.0000" Y="30.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="46.0955" Y="-5.3870" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5010" Y="-0.0533" />
                        <PreSize X="0.8696" Y="0.2970" />
                        <FileData Type="PlistSubImage" Path="btn_genzhu.png" Plist="Game/Dz.plist" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="1118.8114" Y="95.9742" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <TextColor A="255" R="255" G="255" B="255" />
                    <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                    <PressedFileData Type="PlistSubImage" Path="btn.png" Plist="Game/Dz.plist" />
                    <NormalFileData Type="PlistSubImage" Path="btn.png" Plist="Game/Dz.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="B_4" ActionTag="1595931499" Tag="26" IconVisible="False" LeftMargin="303.4130" RightMargin="-395.4130" TopMargin="-146.4742" BottomMargin="45.4742" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="62" Scale9Height="79" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="92.0000" Y="101.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_238" ActionTag="166024626" Tag="3371" IconVisible="False" LeftMargin="5.7106" RightMargin="6.2894" TopMargin="94.3214" BottomMargin="-23.3214" LeftEage="26" RightEage="26" TopEage="9" BottomEage="9" Scale9OriginX="26" Scale9OriginY="9" Scale9Width="28" Scale9Height="12" ctype="ImageViewObjectData">
                        <Size X="80.0000" Y="30.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="45.7106" Y="-8.3214" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.4969" Y="-0.0824" />
                        <PreSize X="0.8696" Y="0.2970" />
                        <FileData Type="PlistSubImage" Path="btn_qipai.png" Plist="Game/Dz.plist" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="349.4130" Y="95.9742" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                    <PressedFileData Type="PlistSubImage" Path="cancel.png" Plist="Game/Dz.plist" />
                    <NormalFileData Type="PlistSubImage" Path="cancel.png" Plist="Game/Dz.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="B_5" ActionTag="-1210409846" Tag="28" IconVisible="False" LeftMargin="969.6966" RightMargin="-1061.6965" TopMargin="-146.4742" BottomMargin="45.4742" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="62" Scale9Height="79" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="92.0000" Y="101.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_236" ActionTag="1164704930" Tag="3369" IconVisible="False" LeftMargin="7.1285" RightMargin="4.8715" TopMargin="91.3870" BottomMargin="-20.3870" LeftEage="26" RightEage="26" TopEage="9" BottomEage="9" Scale9OriginX="26" Scale9OriginY="9" Scale9Width="28" Scale9Height="12" ctype="ImageViewObjectData">
                        <Size X="80.0000" Y="30.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="47.1285" Y="-5.3870" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5123" Y="-0.0533" />
                        <PreSize X="0.8696" Y="0.2970" />
                        <FileData Type="PlistSubImage" Path="btn_jiazhu.png" Plist="Game/Dz.plist" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="1015.6966" Y="95.9742" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                    <PressedFileData Type="PlistSubImage" Path="add.png" Plist="Game/Dz.plist" />
                    <NormalFileData Type="PlistSubImage" Path="add.png" Plist="Game/Dz.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="B_6" ActionTag="1200809944" Tag="904" IconVisible="False" LeftMargin="404.9103" RightMargin="-496.9103" TopMargin="-146.4742" BottomMargin="24.4742" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="62" Scale9Height="100" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="92.0000" Y="122.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="450.9103" Y="85.4742" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                    <PressedFileData Type="PlistSubImage" Path="btn_guopai.png" Plist="Game/Dz.plist" />
                    <NormalFileData Type="PlistSubImage" Path="btn_guopai.png" Plist="Game/Dz.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="B_7" ActionTag="134931703" Tag="3365" IconVisible="False" LeftMargin="1175.9261" RightMargin="-1267.9261" TopMargin="-146.4742" BottomMargin="45.4742" TouchEnable="True" ctype="CheckBoxObjectData">
                    <Size X="92.0000" Y="101.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_234" ActionTag="-2118865382" Tag="3366" IconVisible="False" LeftMargin="3.1288" RightMargin="1.8712" TopMargin="91.3870" BottomMargin="-20.3870" LeftEage="28" RightEage="28" TopEage="9" BottomEage="9" Scale9OriginX="28" Scale9OriginY="9" Scale9Width="31" Scale9Height="12" ctype="ImageViewObjectData">
                        <Size X="87.0000" Y="30.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="46.6288" Y="-5.3870" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5068" Y="-0.0533" />
                        <PreSize X="0.9457" Y="0.2970" />
                        <FileData Type="PlistSubImage" Path="btn_gedaodi.png" Plist="Game/Public.plist" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="1221.9261" Y="95.9742" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <NormalBackFileData Type="PlistSubImage" Path="noNum.png" Plist="Game/Public.plist" />
                    <PressedBackFileData Type="PlistSubImage" Path="noNum.png" Plist="Game/Public.plist" />
                    <DisableBackFileData Type="PlistSubImage" Path="noNum.png" Plist="Game/Public.plist" />
                    <NodeNormalFileData Type="PlistSubImage" Path="gou1.png" Plist="Game/Public.plist" />
                    <NodeDisableFileData Type="PlistSubImage" Path="gou1.png" Plist="Game/Public.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="B_z" ActionTag="229345851" Tag="55" IconVisible="False" LeftMargin="525.0000" RightMargin="-755.0000" TopMargin="-281.8808" BottomMargin="200.8808" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="200" Scale9Height="59" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="230.0000" Y="81.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="640.0000" Y="241.3808" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                    <PressedFileData Type="PlistSubImage" Path="b_zb.png" Plist="Game/Public.plist" />
                    <NormalFileData Type="PlistSubImage" Path="b_zb.png" Plist="Game/Public.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="B_k" ActionTag="-928333809" Tag="56" IconVisible="False" LeftMargin="562.5000" RightMargin="-717.5000" TopMargin="-272.8808" BottomMargin="209.8808" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="125" Scale9Height="41" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="155.0000" Y="63.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="640.0000" Y="241.3808" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                    <PressedFileData Type="PlistSubImage" Path="b_ks.png" Plist="Game/Public.plist" />
                    <NormalFileData Type="PlistSubImage" Path="b_ks.png" Plist="Game/Public.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="B_11" Visible="False" ActionTag="-2049297214" Tag="32" IconVisible="False" LeftMargin="809.3479" RightMargin="-901.3479" TopMargin="-261.0915" BottomMargin="160.0915" TouchEnable="True" FontSize="36" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="62" Scale9Height="79" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="92.0000" Y="101.0000" />
                    <Children>
                      <AbstractNodeData Name="T" ActionTag="-496553025" Tag="33" IconVisible="False" LeftMargin="19.0955" RightMargin="18.9045" TopMargin="31.8196" BottomMargin="33.1804" FontSize="36" LabelText="200" ShadowOffsetX="1.0000" ShadowOffsetY="-1.0000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="54.0000" Y="36.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="46.0955" Y="51.1804" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5010" Y="0.5067" />
                        <PreSize X="0.5870" Y="0.3564" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="26" G="26" B="26" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="855.3479" Y="210.5915" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <TextColor A="255" R="255" G="255" B="255" />
                    <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                    <PressedFileData Type="PlistSubImage" Path="btn.png" Plist="Game/Dz.plist" />
                    <NormalFileData Type="PlistSubImage" Path="btn.png" Plist="Game/Dz.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="B_12" Visible="False" ActionTag="2142072946" Tag="35" IconVisible="False" LeftMargin="910.1815" RightMargin="-1002.1815" TopMargin="-261.0915" BottomMargin="160.0915" TouchEnable="True" FontSize="36" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="62" Scale9Height="79" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="92.0000" Y="101.0000" />
                    <Children>
                      <AbstractNodeData Name="T" ActionTag="-8009635" Tag="36" IconVisible="False" LeftMargin="19.0955" RightMargin="18.9045" TopMargin="31.8196" BottomMargin="33.1804" FontSize="36" LabelText="200" ShadowOffsetX="1.0000" ShadowOffsetY="-1.0000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="54.0000" Y="36.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="46.0955" Y="51.1804" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5010" Y="0.5067" />
                        <PreSize X="0.5870" Y="0.3564" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="26" G="26" B="26" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="956.1815" Y="210.5915" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <TextColor A="255" R="255" G="255" B="255" />
                    <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                    <PressedFileData Type="PlistSubImage" Path="btn.png" Plist="Game/Dz.plist" />
                    <NormalFileData Type="PlistSubImage" Path="btn.png" Plist="Game/Dz.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="B_13" Visible="False" ActionTag="1662036298" Tag="41" IconVisible="False" LeftMargin="1011.0151" RightMargin="-1103.0151" TopMargin="-261.0915" BottomMargin="160.0915" TouchEnable="True" FontSize="36" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="62" Scale9Height="79" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="92.0000" Y="101.0000" />
                    <Children>
                      <AbstractNodeData Name="T" ActionTag="-507980199" Tag="42" IconVisible="False" LeftMargin="19.0955" RightMargin="18.9045" TopMargin="31.8196" BottomMargin="33.1804" FontSize="36" LabelText="200" ShadowOffsetX="1.0000" ShadowOffsetY="-1.0000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="54.0000" Y="36.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="46.0955" Y="51.1804" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5010" Y="0.5067" />
                        <PreSize X="0.5870" Y="0.3564" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="26" G="26" B="26" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="1057.0151" Y="210.5915" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <TextColor A="255" R="255" G="255" B="255" />
                    <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                    <PressedFileData Type="PlistSubImage" Path="btn.png" Plist="Game/Dz.plist" />
                    <NormalFileData Type="PlistSubImage" Path="btn.png" Plist="Game/Dz.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="B_14" Visible="False" ActionTag="-561837122" Tag="38" IconVisible="False" LeftMargin="1111.8488" RightMargin="-1203.8488" TopMargin="-261.0915" BottomMargin="160.0915" TouchEnable="True" FontSize="36" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="62" Scale9Height="79" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="92.0000" Y="101.0000" />
                    <Children>
                      <AbstractNodeData Name="T" ActionTag="-540618195" Tag="39" IconVisible="False" LeftMargin="19.0955" RightMargin="18.9045" TopMargin="31.8196" BottomMargin="33.1804" FontSize="36" LabelText="200" ShadowOffsetX="1.0000" ShadowOffsetY="-1.0000" ShadowEnabled="True" ctype="TextObjectData">
                        <Size X="54.0000" Y="36.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="46.0955" Y="51.1804" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5010" Y="0.5067" />
                        <PreSize X="0.5870" Y="0.3564" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="26" G="26" B="26" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="1157.8488" Y="210.5915" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <TextColor A="255" R="255" G="255" B="255" />
                    <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                    <PressedFileData Type="PlistSubImage" Path="btn.png" Plist="Game/Dz.plist" />
                    <NormalFileData Type="PlistSubImage" Path="btn.png" Plist="Game/Dz.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="h" ActionTag="643730280" Tag="74" IconVisible="False" LeftMargin="321.1065" RightMargin="-973.1065" TopMargin="-294.2325" BottomMargin="212.2325" LeftEage="190" RightEage="190" TopEage="32" BottomEage="32" Scale9OriginX="190" Scale9OriginY="32" Scale9Width="272" Scale9Height="18" ctype="ImageViewObjectData">
                    <Size X="652.0000" Y="82.0000" />
                    <Children>
                      <AbstractNodeData Name="Slider" ActionTag="1988585315" Tag="75" IconVisible="False" LeftMargin="16.4100" RightMargin="180.5900" TopMargin="31.8817" BottomMargin="32.1183" TouchEnable="True" PercentInfo="34" ctype="SliderObjectData">
                        <Size X="455.0000" Y="18.0000" />
                        <Children>
                          <AbstractNodeData Name="Image" ActionTag="-1054413259" Tag="76" IconVisible="False" LeftMargin="-55.0005" RightMargin="400.0005" TopMargin="-84.5270" BottomMargin="35.5270" LeftEage="19" RightEage="19" TopEage="10" BottomEage="10" Scale9OriginX="19" Scale9OriginY="10" Scale9Width="72" Scale9Height="47" ctype="ImageViewObjectData">
                            <Size X="110.0000" Y="67.0000" />
                            <Children>
                              <AbstractNodeData Name="T" ActionTag="1563027922" Tag="77" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="50.0740" RightMargin="49.9260" TopMargin="20.6393" BottomMargin="21.3607" FontSize="22" LabelText="1" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                                <Size X="10.0000" Y="25.0000" />
                                <AnchorPoint ScaleX="0.5696" ScaleY="0.6788" />
                                <Position X="55.7700" Y="38.3307" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="255" G="165" B="0" />
                                <PrePosition X="0.5070" Y="0.5721" />
                                <PreSize X="0.0909" Y="0.3731" />
                                <FontResource Type="Normal" Path="font/FZY4JW.TTF" Plist="" />
                                <OutlineColor A="255" R="149" G="25" B="0" />
                                <ShadowColor A="255" R="26" G="26" B="26" />
                              </AbstractNodeData>
                            </Children>
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="-0.0005" Y="69.0270" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.0000" Y="3.8348" />
                            <PreSize X="0.2418" Y="3.7222" />
                            <FileData Type="PlistSubImage" Path="latiao_ju.png" Plist="Game/Public.plist" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="243.9100" Y="41.1183" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.3741" Y="0.5014" />
                        <PreSize X="0.6979" Y="0.2195" />
                        <BackGroundData Type="PlistSubImage" Path="latiao_td.png" Plist="Game/Public.plist" />
                        <ProgressBarData Type="PlistSubImage" Path="latiao_sd.png" Plist="Game/Public.plist" />
                        <BallNormalData Type="PlistSubImage" Path="latiao_btn.png" Plist="Game/Public.plist" />
                        <BallPressedData Type="PlistSubImage" Path="latiao_btn.png" Plist="Game/Public.plist" />
                        <BallDisabledData Type="PlistSubImage" Path="latiao_btn.png" Plist="Game/Public.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="B" ActionTag="482031088" Tag="78" IconVisible="False" LeftMargin="500.1777" RightMargin="5.8223" TopMargin="7.8197" BottomMargin="6.1803" TouchEnable="True" FontSize="36" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="116" Scale9Height="46" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="146.0000" Y="68.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="573.1777" Y="40.1803" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.8791" Y="0.4900" />
                        <PreSize X="0.2239" Y="0.8293" />
                        <FontResource Type="Normal" Path="font/FZY4JW.TTF" Plist="" />
                        <TextColor A="255" R="255" G="255" B="255" />
                        <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                        <PressedFileData Type="PlistSubImage" Path="latiao_xz.png" Plist="Game/Public.plist" />
                        <NormalFileData Type="PlistSubImage" Path="latiao_xz.png" Plist="Game/Public.plist" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="647.1065" Y="253.2325" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="PlistSubImage" Path="latiao_di.png" Plist="Game/Public.plist" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="640.0000" Y="360.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5000" />
            <PreSize X="1.0000" Y="1.0000" />
            <FileData Type="Normal" Path="Game/public/shezhi/bj1.png" Plist="" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>