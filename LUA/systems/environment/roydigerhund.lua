local psychos = {}
local leaveReally = {}
local lastMsg = {}
local plant = createObject(2251, 2199, -1171.6, 1030.1)
setElementInterior(plant, 15)
setElementDimension(plant, -1)
local cert = createObject(2684, 2197.8, -1169.87, 1030.5)
setElementInterior(cert, 15)
setElementDimension(cert, -1)

local marker = createMarker(914.7, -1816.7, 14, "arrow", 1, 95, 190, 255)

local function psychoSpeak(player, msg)
	outputChatBox("#ff9b00[Psychiater]: #ccf2ff"..msg, player, 0, 0, 0, true)
end

local function leavePsycho(player)
	if (psychos[player]) then
		if (leaveReally[player]) then
			
			psychoSpeak(player, "Schade dass Du noch nicht so weit bist, dich mit deinen Problemen auseinanderzusetzen...")
			
			fadeElementInterior(player, 0, 913.51, -1818.95, 12.99, 0, 0)
			
			setTimer(function()
				destroyElement(psychos[player])
				toggleAllControls(player, true, true, true)
				setCameraTarget(player, player)
				setPedAnimation(player)
			end, 900, 1)
			unbindKey(player, "space", "down", leavePsycho)
			leaveReally[player] = false
			
		else
			
			psychoSpeak(player, "Bist Du dir wirklich sicher? Ich denke nicht das wir deine Probleme schon gelöst haben.")
			leaveReally[player] = true
		end
	end
	
end

local rndSentences = {
"Wie finden Sie meine Krawatte? Die hat meine Mami heute für mich rausgelegt.",
"Was du mir sagst, das vergesse ich. Was du mir zeigst, daran erinnere ich mich. Was du mich tun lässt, das verstehe ich.",
"Der Weg ist das Ziel.",
"Unordentlich denkt der Habgierige im Bunker nach.",
"Alles was jemand über einen anderen aussagt, sagt mindestens genau so viel über den Sprecher aus.",
"Man geht so mit anderen Menschen um, wie früher mit einem selbst umgegangen wurde, und so geht man auch mit sich selbst um.",
"Grün ist zielstrebiger als Rot.",
"Die Dinge sind nie so, wie sie sind. Sie sind immer das, was man aus ihnen macht.",
"Viele Menschen versäumen das kleine Glück, während sie auf das große vergebens warten.",
"Für gewöhnlich stehen nicht die Worte in der Gewalt der Menschen, sondern die Menschen in der Gewalt der Worte.",
"Haben Sie das Klo verstopft?",
"Haben Sie schonmal über Viagra nachgedacht?",
"Vor der Tür ist das Meer. Tun Sie uns doch beiden den gefallen und stürzen Sie sich doch einfach in die Flut.",
"Wer ander'n eine Bratwurst brät, der hat ein Bratwurstbratgerät.",
"Was liegt am Strand und kann man kaum verstehen? Eine Nuschel!",
"Alkohol löst keine Probleme, aber das tut Milch ja auch nicht...",
"Nüchtern betrachtet war es besoffen besser!",
"Realität ist eine Illusion, die durch Mangel von Alkohol hervorgerufen wird.",
"Wer will sucht Wege, wer nicht will, sucht Gründe.",
"Herr Doktor ich komm mir so unglaublich überflüssig vor. - Dr: Der Nächste bitte!",
"Dummheit macht frei.",
"„Das kann jetzt ein bisschen weh tun.“ - Patient: „Kein Problem“ - Dr: „Ich habe seit 3 Jahren ein Verhältnis mit Ihrer Frau.“",
"Haben Sie seit den letzten Mal zugenommen?",
"Ich habe die Lösung für all Ihre Probleme. Ein Sprung aus den 10. Stock.",
"Arzt: „Sie müssen dringend aufhören zu onanieren.“ Patient: „Wieso?“ Arzt: „Ich kann Sie so nicht untersuchen!“",
"Ich habe gehört Dummheit wäre heilbar. Leider ist für Sie die letzte hilfe zu spät gekommen.",
"Mit wie viel Grad wäscht deine Mutter deine Socken in der Waschmaschine?",
"Hab gelernt, dass es gute und schlechte Fette gibt. Du zum Beispiel bist ein schlechtes Fett.",
"Bekommt dein Gehirn eigentlich Arbeitslosengeld?",
"Brot kann schimmeln, du kannst nichts!",
"Du bist wie eine Pizza Margherita - hast halt nichts drauf!",
"Flutscht dir der Föhn in die Wanne, ja dann wars deine letzte Panne.",
"Jesus kann ja über Wasser laufen, richtig? Und Gurken bestehen zu 98% aus Wasser. Ich kann über Gurken laufen. Also bin ich zu 98% Jesus.",
"Dein Kopf ist immer voll. Vorne mit Heu und hinten mit Wasser und wenn es brennt dann brauchst du nur zu nicken.",
"Du bist ein guter Duden! Aufschlagen, zuschlagen und immer wieder nachschlagen!",
"Wer im Glashaus sitz, sollte zum Scheißen in den Keller gehen.",
"Es ist ja nicht so, dass ich dich hasse, aber würdest du brennen und ich hätte Wasser… Ich würd's trinken!", 
"Früher war doch wirklich alles besser. Beispielsweise warst du gestern nicht da...",
"Dein Atem stinkt so, dass wir uns schon auf deine Fürze freuen!",
"Wusstest du, dass die Abk. für Abk. Abk. ist?",
"Du bist wie eine Wolke: Wenn du dich verziehst, kanns noch ein schöner Tag werden!",
"Es heisst doch immer Schönheitsschlaf! Du warst wohl dein ganzes Leben wach!",
"Jetzt wo ich dich sehe, fällt mir ein, dass ich den Müll noch runterbringen muss.",
"Viele der weltgrößten Genies sind tot. Leonardo Da Vinci und Einstein sind gestorben. Also bist du unsterblich oder?",
"Wenn ich deine Fresse hätte, würde ich lachend in eine Kreissäge laufen!",
"Das einzige, was mich hier noch hält, ist die Erdanziehung!",
"Kauf dir bitte ein Seil und erschieße dich.",
"Lass die Frauen links liegen, und dann leg dich daneben.",
"Du bist wie eine kläranlage! Aussen beton und innen scheisse.",
"Ist das ein Fleck auf meiner Couch? Oh das bist du.",
"Die Menschen stolpern nicht über Berge, sondern über Maulwurfshügel.", 
"Essen und Beischlaf sind die beiden großen Begierden des Mannes.",
"Loslassen befreit.",
"Habe ich gesagt „Mülltonne öffne dich“, oder warum redest du mit mir?",
"Nur wer sein Ziel kennt, findet den Weg.",
"Wer A sagt, der muss nicht B sagen. Er kann auch erkennen, dass A falsch war.",
"Man muss vom Weg abkommen, um nicht auf der Strecke zu bleiben.",
"Arroganz ist die Kunst, auf seine eigene Dummheit stolz zu sein.",
}
addEventHandler("onPlayerChat", root, function(msg, typ)
	if (psychos[source] and typ == 0) then
		local rnd = math.random(1, #rndSentences)
		if (type(lastMsg[source]) == "number" and lastMsg[source] == rnd) then rnd = math.random(1, #rndSentences) end
		lastMsg[source] = rnd
		psychoSpeak(source, rndSentences[rnd])
		leaveReally[player] = false
		cancelEvent()
		outputChatBox(getPlayerName(source)..": "..msg, source)
	end
end)


addEventHandler("onMarkerHit", marker, function(player, dim)
	if (dim == true) then
		if (getElementType(player) == "player") then
			
			local dim = math.random(40000,50000)
			fadeElementInterior(player, 15, 2197.17, -1171.27, 1030.3, 0, dim)
			
			setTimer(function()
				setElementPosition(player, 2197.17, -1171.27, 1030.3)
				toggleAllControls(player, true, false)
				setElementRotation(player, 0, 0, 307)
				setTimer(function()
					setPedAnimation(player, "beach", "lay_bac_loop", -1, true, false, true, true)
					setElementRotation(player, 0, 0, 307.1)
				end, 250, 1)
				
				setCameraMatrix(player, 2196.45, -1175.32, 1032.17, 2230.71, -1092.64, 987.55)
				
				local roydigerhund = createPed(57, 2201.0, -1171.3, 1029.88, 90)
				setElementInterior(roydigerhund, 15)
				setElementDimension(roydigerhund, dim)
				setElementData(roydigerhund, "firstLastName", "Prof. Dr. Roy Digerhund")
				
				setTimer(function()
					setElementRotation(roydigerhund, 0, 0, 90)
					setElementCollisionsEnabled(roydigerhund, false)
					setElementPosition(roydigerhund, 2201.0, -1171.3, 1029.88)
					setPedAnimation(roydigerhund, "int_office", "off_sit_bored_loop", -1, true, false, true, true)
					setElementRotation(roydigerhund, 0, 0, 90.1)
				end, 250, 1)
				
				psychos[player] = roydigerhund
				
				bindKey(player, "space", "down", leavePsycho)
				
				
				psychoSpeak(player, "Guten Tag mein Name ist Prof. Dr. Roy Digerhund")
				psychoSpeak(player, "Nun zu Ihnen, lassen sie uns über ihre Probleme sprechen. Erklären Sie mir, was sie bedrückt.")
				
			end, 900, 1)
			
		end
	end
end)