myDeck = '8abae4'
myDiscard = '4a14d3'
canContinue = true

function onLoad()
  button = {click_function = 'nextTurn',
            function_owner = self,
            label = 'Resolve',
            position = {0,0.1,0},
            rotation = {0,0,0},
            width = 2000,
            height = 750,
            font_size = 200,
            tooltip = "Resolve the top card and reveal the next card. The top card of this deck is always revealed.",
            color = {r=0.5,b=0.5,g=1}
          }  -- body...
    self.createButton(button)
    self.setLock(true)
end

--多种情��
--1. 抽牌�����和弃牌堆都为空，直接退出函数
--2. 抽牌堆有卡片��背面朝上则翻开即可；正面朝上则置入弃牌区即可
--3. 抽牌堆没有卡片，但����有牌堆，牌堆一定正面朝下，所以让牌堆��一张翻面即可
--4. 抽牌堆为空，弃牌堆非空
function nextTurn()
  if (canContinue == false) then
    return(nil)
  end

	deckObject = getObjectFromGUID(myDeck)
	Card_or_Deck = find_Card_or_Deck_InZone(deckObject)

	discardObject = getObjectFromGUID(myDiscard)
	findDiscard = find_Card_or_Deck_InZone(discardObject)


	--��况1:抽牌堆和弃牌��都为空，直接退出函数
	if Card_or_Deck == nil and findDiscard == nil then
		broadcastToAll("There is no Foe deck or discard pile!", {r = 1, g = 0, b = 0})
		return
	end
  --情况4：抽牌堆为空，弃牌堆非空
    if Card_or_Deck == nil and findDiscard ~= nil then
      -- broadcastToAll("Shuffle!", {r = 1, g = 0, b = 0})
      findDiscard.setPosition(deckObject.getPosition() + vector(0,1,0))
      findDiscard.setRotation({0,180,180})
      findDiscard.shuffle()
      Wait.time(nextTurn, 0.6)
      return
  end

	--情况2:抽牌堆有卡片
	if Card_or_Deck.tag == "Card" then
		local card_rotation = Card_or_Deck.getRotation()
		--情况2.1：卡片正面朝上，将该卡片置入弃牌区即可
		if(card_rotation.z >= 0 and card_rotation.z <1) then
			local discardPos = discardObject.getPosition() + vector(0,1,0)
			local discardRot = {0,180,0}
			Card_or_Deck.setPositionSmooth(discardPos)
			Card_or_Deck.setRotationSmooth(discardRot)
      --置入弃牌区后再执行一次这个函数（即翻面顶牌）,如果抽牌堆为空，不需要再执行
      local new_Card_or_Deck = nil
      Wait.time(function()
          new_Card_or_Deck = find_Card_or_Deck_InZone(deckObject)
      end, 0.5)
      Wait.time(function()
          if new_Card_or_Deck ~= nil then
              nextTurn()
          end
      end, 0.6)
		--情况2.2：卡片背面朝上，将该卡片翻面即可
		else
			Card_or_Deck.flip()
			canContinue = false
			Wait.time(flipBool,0.5)
			return
		end
	--情����3：抽牌堆没有卡片（Card_or_Deck.tag == "Deck"）
  elseif Card_or_Deck.tag == "Deck" then
    deck_rotation = Card_or_Deck.getRotation()
        --情况3.1：抽牌堆为正面向上的���堆，将�������堆顶的牌直接置入弃牌堆
        if deck_rotation.z >=0 and deck_rotation.z <1 then
          local deck_pos = Card_or_Deck.getPosition()
          local TopCardPositionParam = {position = deck_pos + vector(20.46,1,0), smooth = true, top=true}
          Card_or_Deck.takeObject(TopCardPositionParam)
		  return
        --情况3.2：抽牌堆为��面��上的牌堆，将牌堆顶的牌翻面
        else
          local deck_pos = Card_or_Deck.getPosition()
          local TopCardPositionParam = {position = deck_pos + vector(0,1,0), smooth = true, top=true, flip=true}
          Card_or_Deck.takeObject(TopCardPositionParam)
          canContinue = false
          Wait.time(flipBool,0.5)
			return
        end
	end
end

--检查抽牌堆有无卡牌或牌堆，有则优先返回卡牌对象
function find_Card_or_Deck_InZone(zone)
    local objectsInZone = zone.getObjects()
	--优先检查是���������������有顶牌，有则优先返回卡牌对象
	bottom_card = nil
    for i, object in ipairs(objectsInZone) do
        if object.tag == "Card" then
			--特殊情况：一张正面朝上，另一张背面朝上，则忽略背���朝上的卡牌，返回正面朝上的卡��
			--判��逻���：如果检测���的卡牌背面朝��，���继续检��，保证正面朝上卡���对象的�����先返回
			local rotation = object.getRotation()

			if rotation.z > 179 then
				-- broadcastToAll("this card is bottom")
				bottom_card = object
			else
				-- broadcastToAll("this card is top")
				return getObjectFromGUID(object.guid)
			end


        end
    end
	if(bottom_card ~= nil) then
		return getObjectFromGUID(bottom_card.guid)
	end
	--无卡牌则再检查是否有牌堆，有则返回牌堆������������象
    for i, object in ipairs(objectsInZone) do
        if object.tag == "Deck" then
            return getObjectFromGUID(object.guid)
        end
    end
	--如果都没有
    return nil
end

--翻牌时需����短暂禁止使用按钮
function flipBool()
  canContinue = true
end